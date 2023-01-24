//
//  FilterCardView.swift
//  ShareTrip
//
//  Created by Mac on 12/4/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit


protocol FlightFilterCardViewDelgate: AnyObject {
    func crossButtonTapped()
    func applyButtonTapped()
}

class FlightFilterCardView: UIView {
    
    private var viewModel: FlightFilterViewModel!
    private var filterType: FlightFilterType!
    private var maxContainerHeight: CGFloat!
    weak var delegate: FlightFilterCardViewDelgate?
    weak var bottomLayoutConstraint: NSLayoutConstraint?
    
    //PriceRange
    var minPriceValue: Int?
    var maxPriceValue: Int?
    
    //Schedule
    var departTimeSlotRowIndex: Int?
    var departTimeSlotRowValue: Bool = false
    
    var returnTimeSlotRowIndex: Int?
    var returnTimeSlotRowValue: Bool = false
    
    //Stoppage, Airline, Layover, Weight
    var optionChanges: [Int: Bool] = [:]
    
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .offWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var crossButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"close-mono"), for: .normal)
        button.tintColor = UIColor.greyishBrown
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.crossButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var selectAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("Deselect All".capitalized, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.setTitleColor(.appPrimary, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(selectAllButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.greyishBrown
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var theTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.removeTopSpace()
        tableView.removeBottomSpace()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("APPLY", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .semibold)
        button.backgroundColor = UIColor.appPrimary
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.doneButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    var rowHeight: CGFloat {
        switch filterType {
        case .priceRange:
            return 118.0
        case .stoppage, .airline, .layover, .weight:
            return 56.0
        case .schedule:
            return 56.0
        default:
            return 56.0
        }
    }
    
    var sectionHeight: CGFloat {
        switch filterType {
        case .schedule:
            return 40.0
        default:
            return 1.0
        }
    }
    
    var containerViewHeight: CGFloat {

        let adjustedHeight: CGFloat = 120.0
        
        let sectionCount = viewModel.numberOfSections(for: filterType)
        var rowCount: Int
        if filterType == .schedule {
            rowCount = sectionCount * viewModel.numberOfRows(for: .schedule)
        } else {
            rowCount = viewModel.numberOfRows(for: filterType)
        }
        
        let totalHeight = adjustedHeight + sectionHeight * CGFloat(sectionCount) + rowHeight * CGFloat(rowCount)
        return totalHeight > maxContainerHeight ? maxContainerHeight : totalHeight
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init?(coder aDecoder: NSCoder not implemented") }
    
    /*override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }*/
    
    init(
        filterType: FlightFilterType,
        viewModel: FlightFilterViewModel,
        maxHeight: CGFloat,
        delegate: FlightFilterCardViewDelgate?) {
        super.init(frame: .zero)
        
        self.viewModel = viewModel
        self.filterType = filterType
        self.delegate = delegate
        self.maxContainerHeight = maxHeight
        
        setupInitialData()
        setupView()
    }
    
    deinit {
        STLog.info("FilterCardView deinit")
    }
    
    private func setupInitialData() {
        switch filterType {
        case .stoppage, .airline, .layover, .weight, .refundble:
            let rowCount = viewModel.numberOfRows(for: filterType)
            if !viewModel.hasFilterData(for: filterType) {
                for rowIndex in 0..<rowCount {
                    optionChanges[rowIndex] = false
                }
            } else {
                for rowIndex in 0..<rowCount {
                    optionChanges[rowIndex] = viewModel.filterOptionChecked(for: filterType, rowIndex: rowIndex)
                }
            }

        case .schedule:
            if let rowIndex = viewModel.departTimeSlotRowIndex() {
                departTimeSlotRowIndex = rowIndex
                departTimeSlotRowValue = true
            } else {
                departTimeSlotRowIndex = nil
                departTimeSlotRowValue = false
            }
            
            if let rowIndex = viewModel.returnTimeSlotRowIndex() {
                returnTimeSlotRowIndex = rowIndex
                returnTimeSlotRowValue = true
            } else {
                returnTimeSlotRowIndex = nil
                returnTimeSlotRowValue = false
            }
        default:
            break
        }
    }
    
    private func setupView() {
        titleLabel.text = filterType.title
        backgroundColor = UIColor.black.withAlphaComponent(0.24)
        addAllSubviews()
        setupTableView()
        //setup tableview
        
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: containerViewHeight)
        containerView.roundTopCorners(radius: 8.0, frame: frame)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        tapGesture.delegate = self
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
    }

    private func setSelectAllButtonTitle() {
        let allSelected = optionChanges.values.reduce(true) { $0 && $1 }
        if allSelected {
            selectAllButton.setTitle("DESELECT ALL", for: .normal)
            selectAllButton.setTitleColor(UIColor.greyishBrown, for: .normal)
        } else {
            selectAllButton.setTitle("SELECT ALL", for: .normal)
            selectAllButton.setTitleColor(UIColor.appPrimary, for: .normal)
        }
    }
    
    func addAllSubviews() {
        
        addSubview(containerView)
        containerView.addSubview(crossButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(theTableView)
        containerView.addSubview(doneButton)
        
        containerView.heightAnchor.constraint(equalToConstant: containerViewHeight).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        let layoutConstraint = containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: containerViewHeight)
        layoutConstraint.isActive = true
        bottomLayoutConstraint = layoutConstraint
        
        crossButton.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        crossButton.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        crossButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16.0).isActive = true
        crossButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0).isActive = true

        if filterType == .stoppage || filterType == .airline || filterType == .layover || filterType == .weight || filterType == .refundble {
            containerView.addSubview(selectAllButton)
            selectAllButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
            selectAllButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0).isActive = true
            selectAllButton.centerYAnchor.constraint(equalTo: crossButton.centerYAnchor).isActive = true
            setSelectAllButtonTitle()
        }

        titleLabel.leadingAnchor.constraint(equalTo: crossButton.trailingAnchor, constant: 16.0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: crossButton.centerYAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0).isActive = true
        
        theTableView.topAnchor.constraint(equalTo: crossButton.bottomAnchor, constant: 16.0).isActive = true
        theTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        theTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        doneButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        doneButton.topAnchor.constraint(equalTo: theTableView.bottomAnchor, constant: 0.0).isActive = true
        doneButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    func setupTableView() {
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.separatorStyle = .none
        theTableView.separatorColor = .clear
        
        switch filterType {
        case .priceRange:
            theTableView.registerNibCell(FilterPriceRangeCell.self)
        case .stoppage, .airline, .layover, .weight, .refundble:
            theTableView.registerNibCell(SwitchCell.self)
        case .schedule:
            theTableView.registerCell(ScheduleFilterCell.self)
        default:
            break
        }
    }
    
    //MARK:- Helpers
    
    func showFilterCardView() {
        //layoutIfNeeded()
        bottomLayoutConstraint?.constant = 0
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
    func hideFilterCardView() {
        if let layoutConstraint = bottomLayoutConstraint {
            layoutConstraint.constant = containerViewHeight
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.layoutIfNeeded()
            }) { [weak self] (finished) in
                if finished {
                    self?.removeFromSuperview()
                }
            }
        }
    }
    
    func scheduleRowIndex(from indexPath: IndexPath) -> Int {
        let section = indexPath.section + 1
        let row = indexPath.row + 1
        let index = section * 1000 + row
        return index
    }

    func scheduleCellIndexPath(from rowIndex: Int) -> IndexPath {
        let section: Int = rowIndex/1000
        let row = rowIndex - section * 1000
        return IndexPath(row: row-1, section: section-1)
    }
    
    //MARK:- ACtion
    @objc func viewTapped(_ sender: UIGestureRecognizer) {
        crossButtonTapped()
    }
    
    @objc func crossButtonTapped(_ sender: UIButton? = nil) {
        delegate?.crossButtonTapped()
    }

    @objc private func selectAllButtonTapped(_ sender: UIButton? = nil) {
        let allSlected = optionChanges.values.reduce(true) { $0 && $1 }
        optionChanges.keys.forEach { key in
            optionChanges[key] = !allSlected
        }
        setSelectAllButtonTitle()
        theTableView.reloadData()
    }

    @objc func doneButtonTapped(_ sender: UIButton) {
        
        switch filterType {
        case .priceRange:
            if let minValue = minPriceValue, let maxValue = maxPriceValue {
                viewModel.setPriceRange(minValue: minValue, maxValue: maxValue)
            }
        case .stoppage, .airline, .layover, .weight, .refundble:

            for dic in optionChanges {
                viewModel.handleSwitchStatusChange(for: filterType, rowIndex: dic.key, checked: dic.value)
            }
            
            //Exclude stoppage, if all options are checked
            /*let rowCount = viewModel.numberOfRows(for: .stoppage)
            let checkedCount = stoppageChanges.filter { $0.value }.count
            if checkedCount == rowCount {
                for rowIndex in 0..<rowCount {
                    viewModel.handleSwitchStatusChange(for: .stoppage, rowIndex: rowIndex, checked: false)
                }
            } else {
                for dic in stoppageChanges {
                    viewModel.handleSwitchStatusChange(for: .stoppage, rowIndex: dic.key, checked: dic.value)
                }
            }*/
        case .schedule:
            
            // save data
            if let departRowIndex = departTimeSlotRowIndex {
                viewModel.handleScheduleOptionSelection(indexPath: IndexPath(row: departRowIndex, section: 0), selected: departTimeSlotRowValue)
            }
            if let returnRowIndex = returnTimeSlotRowIndex {
                viewModel.handleScheduleOptionSelection(indexPath: IndexPath(row: returnRowIndex, section: 1), selected: returnTimeSlotRowValue)
            }
        default:
            break
        }
        
        delegate?.applyButtonTapped()
    }
}

extension FlightFilterCardView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections(for: filterType)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(for: filterType, in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch filterType {
        case .priceRange:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FilterPriceRangeCell
            cell.configure(priceRange: viewModel.filterPriceRange, delegate: self)
            return cell
        case .schedule:
            
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ScheduleFilterCell
        
            var cellData = viewModel.scheduleFilterCellData(for: indexPath)
            cellData.selected = false
            if indexPath.section == 0, let departRowIndex = departTimeSlotRowIndex, indexPath.row == departRowIndex {
                cellData.selected = departTimeSlotRowValue
            } else if indexPath.section == 1, let returnRowIndex = returnTimeSlotRowIndex, indexPath.row == returnRowIndex {
                 cellData.selected = returnTimeSlotRowValue
            }
            
            cell.configure(cellData: cellData)
            return cell
            
        case .stoppage, .airline, .layover, .weight, .refundble:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SwitchCell
            let checked = optionChanges[indexPath.row] ?? false
            let title = viewModel.filterOptionTitle(for: filterType, rowIndex: indexPath.row)
            cell.configure(title: title, checked: checked, indexPath: indexPath, delegate: self)
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        
        
        if filterType == .schedule {
            
            //Check ScheduleTimeSlot is Selected
            //viewModel.isScheduleTimeSlotSelected(for: indexPath)
            
            // save data
            //viewModel.handleScheduleOptionSelection(indexPath: indexPath, selected: true)
            
            // deselect previous selected cell
            // select the current cell
            
            if indexPath.section == 1 {
                //Return TimeSlot
                if indexPath.row == returnTimeSlotRowIndex {
                    //returnTimeSlotRowIndex = nil
                    returnTimeSlotRowValue = false
                } else {
                    returnTimeSlotRowIndex = indexPath.row
                    returnTimeSlotRowValue = true
                }
            } else {
                //Depart TimeSlot
                if indexPath.row == departTimeSlotRowIndex {
                    //departTimeSlotRowIndex = nil
                    departTimeSlotRowValue = false
                } else {
                    departTimeSlotRowIndex = indexPath.row
                    departTimeSlotRowValue = true
                }
            }
            
            theTableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch filterType {
        case .schedule:
            return viewModel.scheduleHeaderTitle(for: section)
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}

extension FlightFilterCardView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if let touchedView = touch.view, touchedView.isDescendant(of: containerView) {
            return false
        }
        
        return true
    }
}

extension FlightFilterCardView: PriceRangeCellDelegate {
    func rangeSeekSliderDidChange(minValue: CGFloat, maxValue: CGFloat) {
        //shouldResetFilter = false
        self.minPriceValue = Int(minValue)
        self.maxPriceValue = Int(maxValue)
    }
}

extension FlightFilterCardView: SwitchCellDelegate {
    func switchButtonStatusChanged(status: Bool, cellIndexPath: IndexPath) {
        switch filterType {
        case .stoppage, .airline, .layover, .weight, .refundble:
            optionChanges[cellIndexPath.row] = status
            setSelectAllButtonTitle()
        default:
            break
        }
    }
}
