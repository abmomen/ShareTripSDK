//
//  JTCalendarVC.swift
//  ShareTrip
//
//  Created by Nazmul Islam on 25/3/20.
//  Copyright © 2020 TBBD IOS. All rights reserved.
//

import UIKit
import JTAppleCalendar

public protocol JTCalendarVCDelegate: AnyObject {
    func dateSelectionChanged(selectedDate: Date, for indexPath: IndexPath?)
    func dateSelectionChanged(firstDate: Date, secondDate: Date, for indexPath: IndexPath?)
}

public extension JTCalendarVCDelegate {
    func dateSelectionChanged(selectedDate: Date, for indexPath: IndexPath?) {}
    func dateSelectionChanged(firstDate: Date, secondDate: Date, for indexPath: IndexPath?) {}
}

public protocol JTCalendarViewModelProvider {
    var minAllowableDate: Date? { get }
    var maxAllowableDate: Date? { get }
    var firstDate: Date? { get }
    var lastDate: Date? { get }
    var dateSelectionMode: DateSelectionMode { get }
    var calendarDateRange: (startDate: Date, endDate: Date) { get }
    
    func isValid(_ date: Date, cellState: CellState) -> Bool
    func onNewDateSelected(_ selectedDate: Date)
    func positionTypeForDate(_ date: Date, cellSate: CellState) -> SelectionRangePosition
}

open class JTCalendarVC: UIViewController, JTACMonthViewDataSource, JTACMonthViewDelegate {
    
    public var calendarView: JTCalendarView!
    public var calendar: JTACMonthView { calendarView.calendar }
    public override func loadView() {
        super.loadView()
        loadNibs()
    }
    
    open func loadNibs() {
        let calendarView = JTCalendarView.instantiate()
        self.calendarView = calendarView
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
        
        var safeArea: UILayoutGuide
        if #available(iOS 11.0, *) {
            safeArea = view.safeAreaLayoutGuide
        } else {
            safeArea = view.layoutMarginsGuide
        }
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            calendarView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            calendarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    // MARK: - Configuration Properties
    private var calendarTitle: String?
    private var minAllowableDate: Date?
    private var maxAllowableDate: Date?
    private var firstDateViewData: JTCalendarDateViewData!
    private var secondDateViewData: JTCalendarDateViewData?
    private var dateSelectionMode: DateSelectionMode = .single
    private var allowSingleDateInRangeMode: Bool = false
    private weak var delegate: JTCalendarVCDelegate?
    private var indexPath: IndexPath?
    
    //needed for packge
    private var validDays: [JTAppleCalendar.DaysOfWeek]?
    private var departs: Period.Departs?
    
    /// Must be called before view did load to function properly
    /// If date selection mode is .single, secondComponent is ignored
    public func configure(
        calendarTitle: String? = nil,
        minAllowableDate: Date? = nil,
        maxAllowableDate: Date? = nil,
        firstDateViewData: JTCalendarDateViewData? = nil,
        secondDateViewData: JTCalendarDateViewData? = nil,
        allowSingleDate: Bool = false,
        delegate: JTCalendarVCDelegate? = nil,
        indexPath: IndexPath? = nil
    ) {
        self.calendarTitle = calendarTitle
        self.minAllowableDate = minAllowableDate
        self.maxAllowableDate = maxAllowableDate
        self.firstDateViewData = firstDateViewData ?? JTCalendarDateViewData(title: "From")
        self.secondDateViewData = secondDateViewData ?? JTCalendarDateViewData(title: "To")
        self.dateSelectionMode = .range
        self.allowSingleDateInRangeMode = allowSingleDate
        self.delegate = delegate
        self.indexPath = indexPath
    }
    
    public func configure(
        calendarTitle: String? = nil,
        minAllowableDate: Date? = nil,
        maxAllowableDate: Date? = nil,
        validDays: [JTAppleCalendar.DaysOfWeek]? = nil,
        departs: Period.Departs? = nil,
        dateViewData: JTCalendarDateViewData? = nil,
        delegate: JTCalendarVCDelegate? = nil,
        indexPath: IndexPath? = nil
    ) {
        self.calendarTitle = calendarTitle
        self.minAllowableDate = minAllowableDate
        self.maxAllowableDate = maxAllowableDate
        self.validDays = validDays
        self.departs = departs
        self.firstDateViewData = dateViewData ?? JTCalendarDateViewData(title: "Selected Date")
        self.dateSelectionMode = .single
        self.delegate = delegate
        self.indexPath = indexPath
    }
    
    public var viewModel: JTCalendarViewModelProvider!
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupUI()
    }
    
    private func setupViewModel() {
        viewModel = JTCalendarViewModel(
            minAllowableDate: minAllowableDate,
            maxAllowableDate: maxAllowableDate,
            firstDate: firstDateViewData.selectedDate,
            lastDate: secondDateViewData?.selectedDate,
            validDays: validDays,
            departs: departs,
            dateSelectionMode: dateSelectionMode
        ) { [weak self] in
            self?.onDateSelectionChanged()
        }
    }
    
    private func onDateSelectionChanged() {
        setDateTexts()
        setApplyButtonStatus()
    }
    
    private func setDateTexts() {
        let firstDate = viewModel.firstDate ?? Date()
        let secondDate = viewModel.lastDate ?? firstDate
        calendarView.setDateText(firstDate: firstDate, secondDate: secondDate)
    }
    
    private func setApplyButtonStatus() {
        var isEnabled: Bool
        if viewModel.dateSelectionMode == .range && !allowSingleDateInRangeMode {
            isEnabled = viewModel.firstDate != nil && viewModel.lastDate != nil
        } else {
            isEnabled = viewModel.firstDate != nil
        }
        calendarView.setApplyButtonStatus(isEnabled)
    }
    
    open func setupUI() {
        view.backgroundColor = .appPrimary
        title = calendarTitle ?? "Select Date".getPlural(dateSelectionMode == .range)
        
        calendar.calendarDataSource = self
        calendar.calendarDelegate = self
        
        if viewModel.dateSelectionMode == .range {
            calendar.allowsMultipleSelection = true
            calendar.allowsRangedSelection = true
            calendar.rangeSelectionMode = .continuous
        } else {
            calendar.allowsMultipleSelection = false
            calendar.allowsRangedSelection = false
        }
        
        calendarView.configure(
            firstDateData: firstDateViewData,
            secondDateData: secondDateViewData
        )
        
        calendarView.applyButtonTapCallback = { [weak self] in
            self?.onApplyButtonTap()
        }
        
        setDateTexts()
        setApplyButtonStatus()
        
        // Set and scroll to date if selected date already exists
        if let firstDate = viewModel.firstDate {
            if let lastDate = viewModel.lastDate {
                calendar.selectDates(from: firstDate, to: lastDate, triggerSelectionDelegate: false)
            } else {
                calendar.selectDates([firstDate], triggerSelectionDelegate: false)
            }
            calendar.scrollToHeaderForDate(firstDate)
        }
    }
    
    private func onApplyButtonTap() {
        guard let firstDate = viewModel.firstDate else {
            STLog.error("View model didn't have firstDate selected but apply button is enabled.")
            return
        }
        
        switch viewModel.dateSelectionMode {
        case .range:
            if allowSingleDateInRangeMode {
                let lastDate = viewModel.lastDate ?? firstDate
                delegate?.dateSelectionChanged(firstDate: firstDate, secondDate: lastDate, for: indexPath)
            } else {
                guard let lastDate = viewModel.lastDate else {
                    STLog.error("Single Date Selection is not allowed and View model didn't have last date selected but apply button is enabled.")
                    return
                }
                delegate?.dateSelectionChanged(firstDate: firstDate, secondDate: lastDate, for: indexPath)
            }
        case .single:
            delegate?.dateSelectionChanged(selectedDate: firstDate, for: indexPath)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    open func configureCell(_ cell: JTACDayCell?, cellState: CellState, date: Date) {
        guard let cell = cell as? JTDateCell else { return }
        cell.configure(
            cellState: cellState,
            valid: viewModel.isValid(date, cellState: cellState),
            selectedPosition: viewModel.positionTypeForDate(date, cellSate: cellState)
        )
    }
    
    // MARK: - JTACMonthViewDataSource
    public func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let calendarDateRange = viewModel.calendarDateRange
        return ConfigurationParameters(
            startDate: calendarDateRange.startDate,
            endDate: calendarDateRange.endDate,
            numberOfRows: 10,
            generateOutDates: .tillEndOfRow,
            firstDayOfWeek: .sunday
        )
    }
    
    // MARK: - JTACMonthViewDelegate
    public func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "\(JTDateCell.self)", for: indexPath)
        configureCell(cell, cellState: cellState, date: date)
        return cell
    }
    
    public func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(cell, cellState: cellState, date: date)
    }
    
    public func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "\(JTCalendarHeader.self)", for: indexPath) as! JTCalendarHeader
        header.configure(startingDateOfTheMonth: range.start)
        return header
    }
    
    public func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        /// Called to retrieve the size to be used for the month headers
        return MonthSize(defaultSize: 70.0)
    }
    
    public func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        return viewModel.isValid(date, cellState: cellState) && cellState.dateBelongsTo == .thisMonth
    }
    
    public func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        // Never call configure on user initiated selection
        // If required select the same date programatically again
        
        if cellState.selectionType == .userInitiated {
            viewModel.onNewDateSelected(date)
            
            // get already selected dates
            var datesAffected = calendar.selectedDates
            // cancell user intiated selection
            calendar.deselectAllDates()
            // select new dates
            if let startDate = viewModel.firstDate {
                let endDate = viewModel.lastDate ?? startDate
                let selectedDates = calendar.generateDateRange(from: startDate, to: endDate)
                calendar.selectDates(selectedDates, triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: true)
            }
            
            // Reload visible dates to make sure cell color changes accordingly
            let dateSegment = calendar.visibleDates()
            var visibleDates = [Date]()
            visibleDates.append(contentsOf: dateSegment.indates.map { $0.date} )
            visibleDates.append(contentsOf: dateSegment.outdates.map { $0.date} )
            visibleDates.append(contentsOf: dateSegment.monthDates.map { $0.date} )
            visibleDates = visibleDates.filter { !datesAffected.contains($0) }
            datesAffected.append(contentsOf: visibleDates)
            
            calendar.reloadDates(datesAffected)
            return
        }
        
        configureCell(cell, cellState: cellState, date: date)
    }
    
    public func calendar(_ calendar: JTAppleCalendar.JTACMonthView, shouldDeselectDate date: Date, cell: JTAppleCalendar.JTACDayCell?, cellState: JTAppleCalendar.CellState, indexPath: IndexPath) -> Bool {
        guard viewModel.isValid(date, cellState: cellState) && cellState.dateBelongsTo == .thisMonth else { return false}
        
        // As we will handle all user initiated selection/deselection from didSelectDate method
        // We will not allow user to deselect date manually.
        // we will create handover the responsibilty to didSelectDate method
        // to generate deselection properly
        if cellState.selectionType == .userInitiated {
            self.calendar(calendar, didSelectDate: date, cell: cell, cellState: cellState, indexPath: indexPath)
            return false
        }
        return true
    }
    
    public func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        if cellState.selectionType == .userInitiated { return }
        configureCell(cell, cellState: cellState, date: date)
    }
    
    open func calendarDidScroll(_ calendar: JTACMonthView) {
        // Empty implementation is required
    }
}
