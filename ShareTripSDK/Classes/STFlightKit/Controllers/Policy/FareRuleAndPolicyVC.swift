//
//  FareRuleAndPolicyVC.swift
//  ShareTrip
//
//  Created by Jubayar Hosan on 13/4/21.
//  Copyright © 2021 ShareTrip. All rights reserved.
//

import UIKit
import PKHUD


enum FareRuleTypes {
    case infoLabel
    case readRules
}

class FareRuleAndPolicyVC: ViewController {
    
    @IBOutlet weak private var segmentedController: UISegmentedControl!
    @IBOutlet weak private var fareRulesTV: UITableView!
    
    private var rowType = [FareRuleTypes]()
    private var refundPolicyAttributedString = NSMutableAttributedString()
    private var flightInfoProvider: FlightInfoProvider!
    private var refundRulesString = "<p>Pay attention to the following notifications in the CANCELLATIONS section:</p><p>TICKET IS NON-REFUNDABLE &mdash; the ticket is non-refundable;<br /><br />TICKET IS NON-REFUNDABLE FOR CANCEL/REFUND &mdash; the ticket is non-refundable;<br /><br />REFUND IS NOT PERMITTED &mdash; the ticket is non-refundable;<br /><br />ANY TIME TICKET IS NON-REFUNDABLE &mdash; the ticket is non-refundable;<br /><br />TICKET IS NON-REFUNDABLE IN CASE OF NO-SHOW &mdash; the ticket cannot be refunded in case of no-show.</p><p>Change rules are described in the section with the CHANGES subtitle.</p><p>The CHANGES ARE NOT PERMITTED line means that you cannot make any changes and in such a case, you are not allowed to change the date/time/route of the flight.</p>"
    
    //MARK: - Dependencies
    override func viewDidLoad() {
        setupView()
        initialSetup()
        setupTV()
        setupRightNavBar()
        loadPolicyData()
    }
    
    func setFlightInfo(flightInfoProvider: FlightInfoProvider) {
        self.flightInfoProvider = flightInfoProvider
    }
    
    //MARK: - Init
    private func initialSetup() {
        rowType.removeAll()
        switch flightInfoProvider.getDetailInfoType() {
        case .bagageInfo:
            title = "Baggage Details"
            segmentedController.selectedSegmentIndex = 0
            rowType.append(.infoLabel)
        case .fareDetail:
            title = "Fare Details"
            segmentedController.selectedSegmentIndex = 1
            rowType.append(.infoLabel)
        case .refundPolicy:
            title = "Refund Policy"
            segmentedController.selectedSegmentIndex = 2
            rowType.append(.infoLabel)
            rowType.append(.readRules)
        }
    }
    
    private func setupView() {
        segmentedController.layer.cornerRadius = 5.0
        segmentedController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.appPrimary], for: UIControl.State.selected)
        fareRulesTV.isHidden = true
    }
    
    private func setupRightNavBar() {
        if let user = STAppManager.shared.userAccount {
            navigationItem.rightBarButtonItem = TripCoinBarButtonItem.createWithText(user.totalPoints.withCommas())
        }
    }
    
    //MARK: - IBAction
    @IBAction func segmentedControllerTap(_ sender: UISegmentedControl) {
        rowType.removeAll()
        if sender.selectedSegmentIndex == 0 {
            title = "Baggage Details"
            flightInfoProvider.setDetailInfoType(.bagageInfo)
            rowType.append(.infoLabel)
        } else if sender.selectedSegmentIndex == 1 {
            title = "Fare Details"
            flightInfoProvider.setDetailInfoType(.fareDetail)
            rowType.append(.infoLabel)
        } else if sender.selectedSegmentIndex == 2 {
            title = "Refund Policy"
            flightInfoProvider.setDetailInfoType(.refundPolicy)
            rowType.append(.infoLabel)
            rowType.append(.readRules)
        }
        loadPolicyData()
    }
    
    //MARK: - Helper
    private func showAttributedText(withString: String) {
        let refundPolicyText = """
            Refunds and Date Changes are done as per the following policies.\n
            Refund Amount= Paid Amount – (Airline’s Cancellation Fee + ST Service Fee).\n
            Date Change Amount= Airline’s Date Change Fee + Fare Difference + ST Service Fee. \n\n
            """
        
        let refundPolicyConditions = """
            ☞ ST Convenience fee is non-refundable.\n
            ☞ ShareTrip does not guarantee the accuracy of refund/date change fees.\n
            ☞ The airline refund/date change fee is an estimation and can be changed without any prior notice by the airlines.\n\n
            """
        
        let policyAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.black]
        let conditionsAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 11), .foregroundColor: UIColor.black]
        
        let refundAttributedString = NSAttributedString(string: refundPolicyText, attributes: policyAttributes)
        let refundConditionAttString = NSAttributedString(string: refundPolicyConditions, attributes: conditionsAttributes)
        let refundPolicyAdditionAttString = NSAttributedString(string: withString.htmlToString, attributes: policyAttributes)
        
        refundPolicyAttributedString = NSMutableAttributedString()
        switch flightInfoProvider.getDetailInfoType() {
        case .refundPolicy:
            refundPolicyAttributedString.append(refundAttributedString)
            refundPolicyAttributedString.append(refundConditionAttString)
            refundPolicyAttributedString.append(refundPolicyAdditionAttString)
        default:
            refundPolicyAttributedString.append(refundPolicyAdditionAttString)
        }
        
        DispatchQueue.main.async{
            self.fareRulesTV.isHidden = false
            self.fareRulesTV.reloadData()
            HUD.hide()
        }
    }
    
    private func showHowToReadRules() {
        let webVC = WebViewController()
        webVC.sourceType = .htmlString
        webVC.htmlString = Helpers.generateHtml(content: self.refundRulesString)
        webVC.title = "How to Read Rules"
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    //MARK: - API Calls
    private func loadPolicyData() {
        HUD.show(.progress)
        flightInfoProvider.fetchWebData(completionHandler: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let htmlContent):
                switch self.flightInfoProvider.getDetailInfoType() {
                case .refundPolicy:
                    self.showAttributedText(withString: htmlContent)
                default:
                    self.showAttributedText(withString: htmlContent)
                }
            case .failure:
                self.showAttributedText(withString: "Information not found")
            }
        })
    }
}

//MARK: - Tableview delegate and datasource
extension FareRuleAndPolicyVC: UITableViewDelegate, UITableViewDataSource {
    private func setupTV() {
        fareRulesTV.delegate = self
        fareRulesTV.dataSource = self
        fareRulesTV.separatorStyle = .none
        fareRulesTV.separatorColor = .clear
        fareRulesTV.backgroundColor = .clear
        
        fareRulesTV.registerNibCell(SingleLabelInfoTVCell.self)
        fareRulesTV.registerNibCell(SingleLineInfoCardCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = rowType[indexPath.row]
        switch cellType {
        case .infoLabel:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SingleLabelInfoTVCell
            cell.config(labelText: refundPolicyAttributedString, backgroundColor: UIColor.clear)
            return cell
        case .readRules:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SingleLineInfoCardCell
            cell.configure(title: "How to Read Rules")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = rowType[indexPath.row]
        switch cellType {
        case .infoLabel:
            STLog.info("Infocell tapped")
        case .readRules:
            showHowToReadRules()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - Storyboard extension
extension FareRuleAndPolicyVC: StoryboardBased {
    static var storyboardName: String {
        return "Flight"
    }
}

