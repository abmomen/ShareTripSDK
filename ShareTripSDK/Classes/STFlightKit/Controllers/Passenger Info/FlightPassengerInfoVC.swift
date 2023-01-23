//
//  FlightBookingVC.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 14/10/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit
import PKHUD


//MARK: - Flight Passenger InfoVC Delegate
protocol FlightPassengerInfoVCDelegate: AnyObject {
    func passengerInfoFilled(
        viewController: FlightPassengerInfoVC,
        passengerInfo: PassengerInfo,
        additionalReq: PassengersAdditionalReq,
        for index: Int
    )
    func passengerInfoInputDidFinish(viewController: FlightPassengerInfoVC)
}

class FlightPassengerInfoVC: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()

    private lazy var fileUploadController = {
        return FileUploadController(topViewController: self, imagePicker: imagePicker)
    }()

    var viewModel: FlightPassengerInfoViewModel!
    weak var delegate: FlightPassengerInfoVCDelegate?
    private var presentedCard: PopupInputView?
    private var uploadingFileType: FileType?
    private weak var infoUploadCell: InfoUploadCell?
    var attachment: Bool?

    // MARK: - View Controller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupUI()
        
        viewModel.fetchAdditionalRequirements{ [weak self] success in
            if success {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.isLoading.bindAndFire { loading in
            if loading {
                DispatchQueue.main.async {
                    HUD.show(.progress)
                }
            } else {
                DispatchQueue.main.async {
                    HUD.hide()
                }
            }
        }
        
    }

    // MARK: - Utils
    private func setupTableView() {
        view.addSubview(tableView)
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func setupUI() {
        viewModel?.isLoading.bindAndFire { loading in
            if loading {
                HUD.show(.progress)
            } else {
                HUD.hide()
            }
        }

        viewModel?.uploadingFile.bindAndFire { [weak self] fileType in
            if let type = fileType {
                self?.infoUploadCell?.resetProgressBarView(fileType: type)
            }
        }

        if isModal {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped(_:)))
        } else {
            navigationItem.leftBarButtonItems = BackButton.createWithText("Back", color: UIColor.white, target: self, action: #selector(backButtonTapped(_:)))
        }

        navigationController?.navigationBar.tintColor = UIColor.white
        let barButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtnTapped(_:)))
        self.navigationItem.rightBarButtonItem = barButtonItem

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.registerNibCell(FilterCell.self)
        tableView.registerCell(UITableViewCell.self)
        tableView.registerNibCell(NameInputGuideCell.self)
        tableView.registerNibCell(WarningMessageCell.self)
        
        tableView.registerConfigurableCellDataContainer(SDDateSelectionCell.self)
        tableView.registerConfigurableCellDataContainer(InputTextFieldCell.self)
        tableView.registerConfigurableCellDataContainer(InputTextSelectionCell.self)
        tableView.registerNibConfigurableCellDataContainer(InfoUploadCell.self)
        tableView.registerConfigurableCellDataContainer(GenderSelectionCell.self)
        tableView.registerConfigurableCellDataContainer(CheckboxCell.self)
    }

    private func opentOptionSelecctionCard(indexPath: IndexPath, for rowType: UserInfoRowType) {
        guard let viewModel = viewModel else { return }

        var options = [String]()
        var selectedIndex = 0
        var cardView = PopupSingleOptionSelectionView()
        
        if rowType == .mealPreference {
            options = viewModel.getMealPreferenceOptions()
            selectedIndex = viewModel.getSelectedMealPreferenceIndex()
            cardView = PopupSingleOptionSelectionView(
                title: rowType.title,
                options: options,
                selectedIndex: selectedIndex,
                delegate: self
            )
            
        } else if rowType == .wheelChairRequest {
            options =  viewModel.getWheelChairOptions()
            selectedIndex = viewModel.getSelectedWheelChairOptionIndex()
            
            cardView = PopupSingleOptionSelectionView(
                title: rowType.title,
                options: options,
                selectedIndex: selectedIndex,
                delegate: self
            )
        } else if rowType == .covid19TestInfo {
            selectedIndex = viewModel.getSelectedCovid19TestOptionIndex()
            viewModel.setAddressVisibilityStatus(withSelected: selectedIndex)
            viewModel.generateCovid19TestOptionRows()
            
            cardView = PopupSingleOptionSelectionView(
                title: rowType.title,
                covidTestAmountText: viewModel.getCovid19TestPriceInfo(withSelected: selectedIndex),
                covid19TestCenterDetails: viewModel.getCovidTestCenterDetailsData(),
                options: viewModel.getCovid19TestOptions(),
                selectedCovid19CellIndex: selectedIndex,
                isCovid19TestInfoCell: true,
                covidTestTypeData: viewModel.covid19TestOptionsRowTypes,
                viewModel: self.viewModel,
                delegate: self)
            
        } else if rowType == .travelInsuranceService {
            selectedIndex = viewModel.selectedTravelInsuranceOptionIndex
            viewModel.nameVisibilityStatus(withSelected: selectedIndex)
            viewModel.generateTravelInsuranceOptionsRowTypeData(wihSelected: selectedIndex)
            
            cardView = PopupSingleOptionSelectionView(
                title: rowType.title,
                travelInsuranceAmoutText: viewModel.getTravelInsurancePriceInfo(withSelected: selectedIndex),
                travelInsuranceDetail: viewModel.travelInsuranceDetailsData,
                options: viewModel.travelInsuranceOptions,
                selectedTravelInsuranceCellIndex: selectedIndex,
                isTravelInsuranceInfoCell: true,
                travelInsuranceTypeData: viewModel.travelInsuranceOptionsRowData,
                viewModel: self.viewModel,
                delegate: self
            )
        }
        
        let height = view.frame.size.height * 0.70
        cardView.height = height

        cardView.onOptionSelect = { [weak self] selectedIndexRow in
            if rowType == .mealPreference {
                viewModel.onSelectMealPreference(index: selectedIndexRow)
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            } else if rowType == .wheelChairRequest {
                viewModel.onSelectWheelChairPreference(index: selectedIndexRow)
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            } else if rowType == .covid19TestInfo {
                viewModel.onSelectCovid19TestPreference(index: selectedIndexRow)
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            } else if rowType == .travelInsuranceService {
                viewModel.onSelectTravelInsurancePreference(index: selectedIndexRow)
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        cardView.onGetCovidTestCenterDetails = {
            if rowType == .covid19TestInfo {
                self.showCovidTestCenterDetails()
            }
        }
        
        cardView.onGetTravelInsuranceDetails = {
            if rowType == .travelInsuranceService {
                self.showTravelInsuranceDetail()
            }
        }

        cardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView)

        var constraints = [
            cardView.topAnchor.constraint(equalTo: view.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        if #available(iOS 11.0, *) {
            let bootomLC = cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            constraints.append(bootomLC)
        } else {
            let bootomLC = cardView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
            constraints.append(bootomLC)
        }
        NSLayoutConstraint.activate(constraints)
        presentedCard = cardView
        cardView.show()
    }

    deinit {
        STLog.info("\(String(describing: self)) deinit")
    }

    //MARK: - IBActions
    @objc private func cancelButtonTapped(_ sender: UIBarButtonItem) {
        viewModel?.didFinish()
    }

    @objc private func backButtonTapped(_ sender: UIBarButtonItem) {
        viewModel?.didFinish()
    }

    @objc private func doneBtnTapped(_ sender: UIBarButtonItem) {
        viewModel?.submit()
    }
    
    private func showCovidTestCenterDetails() {
        let webVC = WebViewController()
        webVC.sourceType = .htmlString
        let htmlStr = Helpers.generateHtml(content: viewModel.getCovid19TestCenterDetails().htmlStr)
        webVC.htmlString = htmlStr
        webVC.title = viewModel.getCovid19TestCenterDetails().testCenterName
        self.present(webVC, animated: true, completion: nil)
    }
    
    private func showTravelInsuranceDetail() {
        let webVC = WebViewController()
        webVC.sourceType = .htmlString
        let htmlStr = Helpers.generateHtml(content: viewModel.gettravelInsuranceDetails.htmlStr)
        webVC.htmlString = htmlStr
        webVC.title = viewModel.gettravelInsuranceDetails.name
        self.present(webVC, animated: true, completion: nil)
    }
}

//MARK: - UITableView Delegate & Datasource
extension FlightPassengerInfoVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSection ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(in: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            return tableView.dequeueReusableCell(forIndexPath: indexPath)
        }

        let rowType = viewModel.sections[indexPath.section][indexPath.row]
        switch rowType {
        case .nameInputGuideline:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as NameInputGuideCell
            return cell
        
        case .warning:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as WarningMessageCell
            cell.configure(with: "Meal and wheelchair services are accessible if provided by the airlines (depends on availability).")
            cell.selectionStyle = .none
            return cell
        
        case .mealPreference:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FilterCell
            let options = viewModel.getMealPreferenceOptions()
            let idx = viewModel.getSelectedMealPreferenceIndex()
            let subtitle = options[idx]
            cell.configure(
                title: rowType.title,
                subTitle: subtitle
            )
            return cell
            
        case .wheelChairRequest:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FilterCell
            let options = viewModel.getWheelChairOptions()
            let idx = viewModel.getSelectedWheelChairOptionIndex()
            let subtitle = options[idx]
            cell.configure(
                title: rowType.title,
                subTitle: subtitle
            )
            return cell
            
        case .covid19TestInfo:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FilterCell
            let subtitle = viewModel.getCovid19TestSubtitleString(using: viewModel.getSelectedCovid19TestOptionIndex())
            cell.configure(
                title: rowType.title,
                subTitle: subtitle
            )
            return cell
            
        case .travelInsuranceService:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FilterCell
            let subtitle = viewModel.getTravelInsuranceSubtitleString(using: viewModel.selectedTravelInsuranceOptionIndex)
            cell.configure(
                title: rowType.title,
                subTitle: subtitle
            )
            return cell
            
        default:
            guard let rowViewModel = viewModel.dataForRow(at: indexPath),
                  let cell = tableView.dequeueReusableCell(withIdentifier: type(of: rowViewModel).reuseableIDForContainer, for: indexPath) as? ConfigurableTableViewCell else {
                return tableView.dequeueReusableCell(forIndexPath: indexPath)
            }
            cell.configure(viewModel: rowViewModel)
            
            if let infoUploadCell = cell as? InfoUploadCell {
                self.infoUploadCell = infoUploadCell
                self.infoUploadCell?.didSelectUpload = {[weak self] fileType in
                    self?.viewModel.uploadButtonTapped(type: fileType, indexPath: indexPath)
                }
            }
            
            if let genderCell = cell as? GenderSelectionCell {
                genderCell.didSelectGender = {[weak self] selectedGender in
                    self?.viewModel.genderSelectionChanged(for: indexPath, selectedGender: selectedGender)
                }
            }
            
            if let checkboxCell = cell as? CheckboxCell {
                checkboxCell.didTapCheckbox = {[weak self] checked in
                    self?.viewModel.shouldAddUpdatePassenger = checked
                }
            }
            
            if let inputTextSelectionCell = cell as? InputTextSelectionCell {
                inputTextSelectionCell.didSelectText = {[weak self] selectedValue, selectedRow in
                    self?.viewModel.didSelectText(for: indexPath, text: selectedValue, selectedRow: selectedRow)
                }
            }
            
            if let inputTextFieldCell = cell as? InputTextFieldCell {
                inputTextFieldCell.didChangeText = {[weak self] text in
                    self?.viewModel.didChangeText(for: indexPath, text: text)
                }
            }
            
            if let dateSelectionCell = cell as? SDDateSelectionCell {
                dateSelectionCell.callback.didSelectedDate = {[weak self] date in
                    self?.viewModel.didSelectDate(for: indexPath, date)
                }
            }
            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        let rowType = viewModel.sections[indexPath.section][indexPath.row]
        switch rowType {
        case .mealPreference, .wheelChairRequest, .covid19TestInfo, .travelInsuranceService:
                opentOptionSelecctionCard(indexPath: indexPath, for: rowType)
                tableView.deselectRow(at: indexPath, animated: true)
            default:
                break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let viewModel = viewModel else { return UITableView.automaticDimension }
        let rowType = viewModel.sections[indexPath.section][indexPath.row]
        switch rowType {
        case .mealPreference, .wheelChairRequest, .covid19TestInfo, .travelInsuranceService:
            return 72.0
        default:
            return UITableView.automaticDimension
        }
    }
}

//MARK: - FlightPassengerInfo ViewModel Delegate
extension FlightPassengerInfoVC: FlightPassengerInfoViewModelViewDelegate {
    func passengerInfoInputDidFinish() {
        delegate?.passengerInfoInputDidFinish(viewController: self)
    }

    func passengerInfoFilled(passengerInfo: PassengerInfo, for index: Int) {
        let selectedIndex = viewModel.selectedIndex
        delegate?.passengerInfoFilled(viewController: self, passengerInfo: passengerInfo, additionalReq: viewModel.getPassengerAdditionalRequirements(with: selectedIndex), for: index)
    }

    func validationError(for indexPath: IndexPath, message: String, completion: (() -> Void)?) {
        showMessage(message, type: .error, options: [.autoHideDelay(5), .hideOnTap(true)])
        tableView.reloadData() {
            completion?()
        }
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }

    func onDataChanged(viewModel: FlightPassengerInfoViewModel) {
        UIView.performWithoutAnimation {
            for index in 0..<viewModel.numberOfSection {
                self.tableView.reloadSections(IndexSet(integer: index), with: .none)
            }
        }
    }

    func onAddUpdateStatusChanged(viewModel: FlightPassengerInfoViewModel) {
        let section = viewModel.numberOfSection - 1
        let row = viewModel.numberOfRows(in: section) - 1
        tableView.reloadRows(at: [IndexPath(row: row, section: section)], with: .automatic)
    }

    func uploading(progress: Float) {
        if let fileType = viewModel?.uploadingFile.value {
            DispatchQueue.main.async { [weak self] in
                self?.infoUploadCell?.updateProgressBarView(progress: progress, fileType: fileType)
            }
        }
    }

    func failedToUpload(with error: String) {
        showMessage(error, type: .error)
    }

    func uploadFinished() {
        tableView.reloadData()
    }

    func uploadFile(type: FileType, with urlStr: String) {
        uploadingFileType = type
        if urlStr.count > 0 {
            fileUploadController.showAttachmentActionSheet(attachmentURL: urlStr, title: "View File")
        } else {
            fileUploadController.showOptionsActionActionSheet()
        }
    }
}

//MARK: - UIImagePicker & UiNavigationController Delegate
extension FlightPassengerInfoVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let imageData = image.getResizedDataTo1MB() else {
            STLog.error("Can't parse media as image data")
            return
        }
        guard let fileType = uploadingFileType else {
            return
        }
        viewModel?.didFinishPickingMedia(for: fileType, mediaData: imageData)
        uploadingFileType = nil
    }
}

//MARK: - PopUpInput View Delegate
extension FlightPassengerInfoVC: PopupInputViewDelegate {
    func crossButtonTapped() {
        presentedCard?.hide()
        tableView.reloadData()
    }
}



