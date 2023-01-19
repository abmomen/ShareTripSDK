//
//  InputPopupCardView.swift
//  ShareTrip
//
//  Created by Nazmul Islam on 23/4/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit
import STCoreKit

class PopupSingleOptionSelectionView: PopupInputView {

    // MARK: - UI Components
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()

    // MARK: - Instance Properties
    private var options: [String]
    private var selectedIndex: Int?
    private var selectedCovid19CellIndex: Int?
    private var isCovid19TestInfoCell: Bool = false
    private var covidTestTypeData = [Covid19TestOptionsRowType]()
    private var viewModel: FlightPassengerInfoViewModel!
    private var covidTestAmountText: NSMutableAttributedString

    private var travelInsuranceAmoutText: NSMutableAttributedString
    private var travelInsuranceDetail: [TravelInsuranceDetails] = [TravelInsuranceDetails]()
    private var isTravelInsuranceInfoCell: Bool = false
    private var travelInsuranceTypeData: [TravelInsuranceOptionsRowType] = [TravelInsuranceOptionsRowType]()
    private var selectedTravelInsuranceCellIndex: Int?

    typealias OptionSelectionCallback = (Int) -> Void
    var onOptionSelect: OptionSelectionCallback?

    typealias OnGetCovidTestCenterDetailsCallBack = () -> Void
    var onGetCovidTestCenterDetails:OnGetCovidTestCenterDetailsCallBack?

    typealias onGetTravelInsuranceDetails = () -> Void
    var onGetTravelInsuranceDetails: onGetTravelInsuranceDetails?

    private var addressText: String = ""
    weak var emptyMessageView: ErrorView?
    private var covid19TestCenterDetails: [Covid19TestCenterDetails] = [Covid19TestCenterDetails]()

    // MARK: - Initializers / Deinitializers
    init(title: String = "",
         covidTestAmountText: NSMutableAttributedString = NSMutableAttributedString(),
         travelInsuranceAmoutText: NSMutableAttributedString = NSMutableAttributedString(),
         covid19TestCenterDetails: [Covid19TestCenterDetails] = [Covid19TestCenterDetails](),
         travelInsuranceDetail: [TravelInsuranceDetails] = [TravelInsuranceDetails](),
         options: [String] = [String](),
         selectedIndex: Int? = nil,
         selectedCovid19CellIndex: Int? = nil,
         selectedTravelInsuranceCellIndex: Int? = nil,
         isCovid19TestInfoCell: Bool = false,
         isTravelInsuranceInfoCell: Bool = false,
         covidTestTypeData: [Covid19TestOptionsRowType] = [Covid19TestOptionsRowType](),
         travelInsuranceTypeData: [TravelInsuranceOptionsRowType] = [TravelInsuranceOptionsRowType](),
         viewModel: FlightPassengerInfoViewModel? = nil,
         delegate: PopupInputViewDelegate? = nil) {

        self.covidTestAmountText = covidTestAmountText
        self.travelInsuranceAmoutText = travelInsuranceAmoutText
        self.covid19TestCenterDetails = covid19TestCenterDetails
        self.travelInsuranceDetail = travelInsuranceDetail
        self.options = options
        self.selectedIndex = selectedIndex
        self.selectedCovid19CellIndex = selectedCovid19CellIndex
        self.selectedTravelInsuranceCellIndex = selectedTravelInsuranceCellIndex
        self.isCovid19TestInfoCell = isCovid19TestInfoCell
        self.isTravelInsuranceInfoCell = isTravelInsuranceInfoCell
        self.covidTestTypeData = covidTestTypeData
        self.travelInsuranceTypeData = travelInsuranceTypeData
        self.viewModel = viewModel

        super.init(title: title, delegate: delegate)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder: NSCoder not implemented")
    }

    deinit {
        STLog.info("\(Self.self) deinit")
    }

    // MARK: - Helper Methods and Button Action
    private func setupView() {
        tableView.registerNibCell(LearnMoreCell.self)
        tableView.registerNibCell(OptionSelectTBCell.self)
        tableView.registerNibCell(CovidInfoCell.self)
        tableView.registerNibCell(CovidTestChargeCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        addAllSubviews()
    }

    private func addAllSubviews() {
        containerView.addSubview(tableView)
        let constraints = [
            tableView.topAnchor.constraint(equalTo: crossButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - TravelInsurance Functionalities
    private func travelInsuranceNameTyped(indexPath: IndexPath, text: String) {
        viewModel.travelInsuranceNameTypeInfo(with: selectedTravelInsuranceCellIndex ?? 1, name: text)
    }

    private func travelInsuranceDetail(indexPath: IndexPath, details: TravelInsuranceDetails?) {
        viewModel.fetchTravelInsuranceDetails(code: details?.code ?? "") { [weak self] success in
            if success {
                self?.onGetTravelInsuranceDetails?()
            } else {
                STLog.info("Can't fetch details data")
            }
        }
    }

    private func collectionViewHeightForInsurance() -> CGFloat {
        let totalData = Double(self.travelInsuranceTypeData.count) / 2
        let height = (ceil(totalData) * 130.0) + 50.0
        return CGFloat(height)
    }

    private func prepareReloadTVDataForInsurance() {
        viewModel.nameVisibilityStatus(withSelected: selectedTravelInsuranceCellIndex ?? 1)
        self.travelInsuranceAmoutText = viewModel.getTravelInsurancePriceInfo(withSelected: selectedTravelInsuranceCellIndex ?? 1)
    }


    // MARK: - COVID 19 Functionalities
    private func covid19TestAddressTyped(indexPath: IndexPath, text: String){
        viewModel.setCovid19TestAddressInfo(with: text, and: selectedCovid19CellIndex ?? 1)
    }

    private func covid19TestCenterDetails(indexPath: IndexPath, testCenterDetails: Covid19TestCenterDetails?) {
        viewModel.fetchCovid19TestCenterDetails(withCode: testCenterDetails?.code ?? "") { [weak self] (success) in
            if success {
                self?.onGetCovidTestCenterDetails?()
            } else {
                STLog.info("Can't fetch details data")
            }
        }
    }

    private func getCollectionviewHeight() -> CGFloat {
        let totalData = Double(self.covid19TestCenterDetails.count) / 2
        let height = (ceil(totalData) * 130.0) + 50.0
        return CGFloat(height)
    }

    private func addEmptyMessageView(icon: String, message: String) {
        let emptyMessageView = ErrorView(frame: self.containerView.bounds,
                                         imageName: icon,
                                         title: "Sorry!",
                                         message: message,
                                         imageViewHeight: 100.0,
                                         imageViewWidth: 100.0,
                                         buttonTitle: "Ok",
                                         isBackgroundColorWhite: false)

        emptyMessageView.buttonCallback = { [weak self] in
            self?.crossButtonTapped()
        }

        emptyMessageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(emptyMessageView)

        emptyMessageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        emptyMessageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        emptyMessageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40.0).isActive = true
        emptyMessageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        containerView.bringSubviewToFront(emptyMessageView)
        self.emptyMessageView = emptyMessageView
    }

    private func removeEmptyMessageView() {
        emptyMessageView?.removeFromSuperview()
        emptyMessageView = nil
    }
    // FIXME: - Temporary Image String Used.
    func showEmptyErrorView() {
        if isTravelInsuranceInfoCell {
            addEmptyMessageView(icon: "covid-mono", message: "Travel Insurance not found for this flight")
        } else if isCovid19TestInfoCell {
            addEmptyMessageView(icon: "covid-mono", message: "COVID-19 test info not found for this flight")
        }
    }

    private func prepareReloadeTVData() {
        viewModel.setAddressVisibilityStatus(withSelected: selectedCovid19CellIndex ?? 1)
        self.covidTestAmountText = viewModel.getCovid19TestPriceInfo(withSelected: selectedCovid19CellIndex ?? 1)
    }
}

//MARK:- TableView Datasource
extension PopupSingleOptionSelectionView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if options.count == 0 {
            showEmptyErrorView()
            return 0
        }
        removeEmptyMessageView()
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isCovid19TestInfoCell {
            let rowType = covidTestTypeData[indexPath.row]
            switch rowType {
            case .testCharge:
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CovidTestChargeCell
                cell.config(amountText: self.covidTestAmountText,
                            text: "Covid-19 Test Charge:",
                            description: "RT-PCR test is mandatory for all international travels from Govt. approved labs.")
                cell.selectionStyle = .none
                return cell
            case .optionSelect :
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CovidInfoCell
                let callBackClosure: ((IndexPath, String) -> Void) = { [weak self] (cellIndex, text) in self?.covid19TestAddressTyped(indexPath: cellIndex, text: text)}
                cell.configure(indexPath: indexPath, text: options[indexPath.row], selected: selectedCovid19CellIndex == indexPath.row, isTextInputHidden: viewModel.getAddressVisibilityStatus(withSelected: indexPath.row), testAddress: viewModel.getCovid19TestAddressInfo(with: indexPath.row),  callbackClosure: callBackClosure)
                return cell
            case .learnMore:
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LearnMoreCell
                cell.callback.covidDetail = {[weak self] index, detail in
                    self?.covid19TestCenterDetails(indexPath: index, testCenterDetails: detail)
                }
                cell.config(indexPath: indexPath, covid19TestCenterDetail: self.covid19TestCenterDetails, type: .covid)
                cell.selectionStyle = .none
                return cell
            }
        } else if isTravelInsuranceInfoCell {
            let rowType = travelInsuranceTypeData[indexPath.row]
            switch rowType {
            case .charge:
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CovidTestChargeCell
                cell.config(amountText: self.travelInsuranceAmoutText,
                            text: "Insurance Charge:",
                            description: "Travel Insurance is needed for secure your journey and take the risk")
                cell.selectionStyle = .none
                return cell
            case .optionSelect:
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CovidInfoCell
                let callBack: ((IndexPath, String) -> Void) = { [weak self] (index , text) in
                    self?.travelInsuranceNameTyped(indexPath: index, text: text)
                }
                cell.configure(indexPath: indexPath,
                               text: options[indexPath.row],
                               selected: selectedTravelInsuranceCellIndex == indexPath.row,
                               isTextInputHidden: false,
                               testAddress: "",
                               callbackClosure: callBack)
                return cell
            case .learnMore:
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LearnMoreCell
                cell.callback.insuranceDetail = {[weak self] index, detail in
                    self?.travelInsuranceDetail(indexPath: index, details: detail)
                }
                cell.configureForInsurance(indexPath: indexPath,
                                           type: .insurance,
                                           detail: self.travelInsuranceDetail)
                cell.selectionStyle = .none
                return cell
            }
        }

        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as OptionSelectTBCell
        cell.configure(text: options[indexPath.row], selected: selectedIndex == indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isCovid19TestInfoCell {
            let rowType = covidTestTypeData[indexPath.row]
            switch rowType {
            case .testCharge:
                return 130.0
            case .optionSelect:
                return UITableView.automaticDimension
            case .learnMore:
                return getCollectionviewHeight()
            }
        } else if isTravelInsuranceInfoCell {

            let rowType = travelInsuranceTypeData[indexPath.row]
            switch rowType {
            case .charge:
                return 130.0
            case .optionSelect:
                return UITableView.automaticDimension
            case .learnMore:
                return  collectionViewHeightForInsurance()
            }
        }
        return UITableView.automaticDimension
    }
}

//MARK:- TableView Delegate
extension PopupSingleOptionSelectionView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        if isCovid19TestInfoCell {
            let rowType = covidTestTypeData[indexPath.row]
            switch rowType {
            case .testCharge, .learnMore:
                STLog.info("No need to return anything")
            case .optionSelect:
                selectedCovid19CellIndex = indexPath.row
                prepareReloadeTVData()
            }
        } else if isTravelInsuranceInfoCell {
            let rowType = travelInsuranceTypeData[indexPath.row]
            switch rowType {
            case .charge, .learnMore:
                STLog.info("No need to return anything")
            case .optionSelect:
                selectedTravelInsuranceCellIndex = indexPath.row
                prepareReloadTVDataForInsurance()
            }
        }

        tableView.reloadData { [weak self] in
            guard let self = self else { return }
            self.onOptionSelect?(
                indexPath.row
            )
        }
    }
}
