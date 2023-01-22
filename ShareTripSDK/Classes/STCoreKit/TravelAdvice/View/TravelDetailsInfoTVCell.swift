//
//  TravelDetailsInfoTVCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 11/11/2020.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit

class TravelDetailsInfoTVCell: UITableViewCell {

    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var entryRestrictionHeaderLabel: UILabel!
    @IBOutlet weak private var entryRestrictionDetailsLabel: UILabel!
    @IBOutlet weak private var entryRestrictionToggleButton: UIButton!

    @IBOutlet weak private var requirementsHeaderLabel: UILabel!
    @IBOutlet weak private var quarentineRequiredLabel: UILabel!
    @IBOutlet weak private var covidTestRequiredLabel: UILabel!
    @IBOutlet weak private var maskRequiredLabel: UILabel!

    @IBOutlet weak private var recommandationHeaderLabel: UILabel!
    @IBOutlet weak private var recommandationDetailsLabel: UILabel!
    @IBOutlet weak private var recommandationToggleButton: UIButton!

    @IBOutlet weak private var adviceHeaderLabel: UILabel!
    @IBOutlet weak private var adviceDetailsLabel: UILabel!

    @IBOutlet weak private var newTotalCaseLabel: UILabel!
    @IBOutlet weak private var totalCaseNumberLabel: UILabel!
    @IBOutlet weak private var newDeathCaseLabel: UILabel!
    @IBOutlet weak private var totalDeathNumberLabel: UILabel!

    @IBOutlet weak private var covidInfoLabel: UILabel!
    @IBOutlet weak private var lastUpdateTimeLabel: UILabel!

    private var cellIndexPath: IndexPath!
    private var callbackClosure: ((IndexPath) -> Void)?
    private var travelAdviceVM = TravelAdviceViewModel()

    private var isRestrictionDetailVisible: Bool = false
    private var isRecommandationDetailVisible: Bool = true


    //MARK: - Cell lifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


    //MARK: - Utils
    private func initialSetup(){
        containerView.layer.cornerRadius = 8.0
    }

    func configureCell(indexPath: IndexPath, travelAdviceVM: TravelAdviceViewModel, callbackClosure: ((_ cellIndexPath: IndexPath) -> Void)?) {
        cellIndexPath = indexPath
        self.callbackClosure = callbackClosure
        self.travelAdviceVM = travelAdviceVM

        entryRestrictionHeaderLabel.text = "Recommandation by the country \(self.travelAdviceVM.getDestinationDetailsData().countryName):"
        requirementsHeaderLabel.text = "Requirements by country \(self.travelAdviceVM.getDestinationDetailsData().countryName):"

        quarentineRequiredLabel.text = self.travelAdviceVM.getDestinationDetailsData().requirements.quarentine
        covidTestRequiredLabel.text = self.travelAdviceVM.getDestinationDetailsData().requirements.test
        maskRequiredLabel.text = self.travelAdviceVM.getDestinationDetailsData().requirements.mask

        recommandationHeaderLabel.text = "Entry Restrictions by country \(self.travelAdviceVM.getDestinationDetailsData().countryName):"

        adviceHeaderLabel.text = "Advice for the traveler by \(self.travelAdviceVM.getDestinationDetailsData().countryName):"
        adviceDetailsLabel.text = self.travelAdviceVM.getDestinationDetailsData().advice

        covidInfoLabel.text = "\((self.travelAdviceVM.getDestinationDetailsData().countryName)) has had \(travelAdviceVM.getDestinationDetailsData().newCases) cases for 1 day"


        newTotalCaseLabel.text = "New \(self.travelAdviceVM.getDestinationDetailsData().newCases)"
        totalCaseNumberLabel.text = "\(self.travelAdviceVM.getDestinationDetailsData().totalCases)"

        newDeathCaseLabel.text = "New \(self.travelAdviceVM.getDestinationDetailsData().newDeath)"
        totalDeathNumberLabel.text = "\(self.travelAdviceVM.getDestinationDetailsData().totalDeath)"

        let date = (self.travelAdviceVM.getDestinationDetailsData().time).toDate()
        let time = date?.toString(format: .isoDate)
        lastUpdateTimeLabel.text = "- Last update: \(time ?? "")"

        self.handleToggleActions()
    }

    private func handleToggleActions(){
        /// handle restrictions toggling
        if isRestrictionDetailVisible {
            recommandationDetailsLabel.text = self.travelAdviceVM.getDestinationDetailsData().countryRestriction
            recommandationToggleButton.setImage(UIImage(named: "arrow-up-mono"), for: .normal)
        } else {
            recommandationDetailsLabel.text = ""
            recommandationToggleButton.setImage(UIImage(named: "arrow-down-mono"), for: .normal)
        }

        /// handle recommandation toggling
        if isRecommandationDetailVisible {
            entryRestrictionDetailsLabel.text = self.travelAdviceVM.getDestinationDetailsData().countryRecommandation
            entryRestrictionToggleButton.setImage(UIImage(named: "arrow-up-mono"), for: .normal)

        } else {
            entryRestrictionDetailsLabel.text = ""
            entryRestrictionToggleButton.setImage(UIImage(named: "arrow-down-mono"), for: .normal)
        }

    }

    //MARK: - IBAction
    @IBAction private func recommandationToggleButtonTap(_ sender: Any) {
        isRestrictionDetailVisible.toggle()
        callbackClosure?(cellIndexPath)
    }

    @IBAction func restrictionToggleButtonTap(_ sender: Any) {
        isRecommandationDetailVisible.toggle()
        callbackClosure?(cellIndexPath)
    }
}
