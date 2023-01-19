//
//  JTCalendarViewModel.swift
//  ConfigurableCalendar
//
//  Created by Sharetrip-iOS on 02/03/2020.
//  Copyright © 2020 TBBD. All rights reserved.
//

import Foundation
import JTAppleCalendar

public enum DateSelectionMode {
    case single, range
}

public class JTCalendarViewModel: JTCalendarViewModelProvider {
    
    public private(set) var minAllowableDate: Date?
    public private(set) var maxAllowableDate: Date?
    public private(set) var firstDate: Date?
    public private(set) var lastDate: Date?
    public private(set) var validDays: [JTAppleCalendar.DaysOfWeek]?
    public private(set) var departs: Period.Departs?
    public private(set) var dateSelectionMode: DateSelectionMode
    
    public var calendarDateRange: (startDate: Date, endDate: Date) {
        var _minDate: Date
        var _maxDate: Date
        
        if let minDate = minAllowableDate, let maxDate = maxAllowableDate {
            _minDate = minDate
            _maxDate = maxDate
        } else if let minDate = minAllowableDate {
            _minDate = minDate
            _maxDate = Calendar(identifier: .gregorian).startOfDay(for: minDate.adjust(.year, offset: 1))
        } else if let maxDate = maxAllowableDate {
            _minDate = Calendar(identifier: .gregorian).startOfDay(for: maxDate.adjust(.year, offset: -1))
            _maxDate = maxDate
        } else {
            _minDate = Calendar(identifier: .gregorian).startOfDay(for: Date())
            _maxDate = Calendar(identifier: .gregorian).startOfDay(for: _minDate.adjust(.year, offset: 1))
        }
        
        if _minDate > _maxDate { swap(&_minDate, &_maxDate) }
        
        return (startDate: _minDate, endDate: _maxDate)
    }
    
    private var dateSelectionChangedCallback: ()->Void
    init(minAllowableDate: Date? = nil,
         maxAllowableDate: Date? = nil,
         firstDate: Date? = nil,
         lastDate: Date? = nil,
         validDays: [JTAppleCalendar.DaysOfWeek]?,
         departs: Period.Departs?,
         dateSelectionMode: DateSelectionMode,
         onDateSelectionChanged callback: @escaping ()->Void) {
        if let minAllowableDate = minAllowableDate {
            self.minAllowableDate = Calendar(identifier: .gregorian).startOfDay(for: minAllowableDate)
        }
        if let maxAllowableDate = maxAllowableDate {
            self.maxAllowableDate = Calendar(identifier: .gregorian).startOfDay(for: maxAllowableDate)
        }
        if let firstDate = firstDate {
            self.firstDate = Calendar(identifier: .gregorian).startOfDay(for: firstDate)
        }
        if let lastDate = lastDate {
            self.lastDate = Calendar(identifier: .gregorian).startOfDay(for: lastDate)
        }
        self.validDays = validDays
        self.departs = departs
        self.dateSelectionMode = dateSelectionMode
        self.dateSelectionChangedCallback = callback
    }
    
    public func isValid(_ date: Date, cellState: CellState) -> Bool {
        if let minDate = minAllowableDate, let maxDate = maxAllowableDate {
            return minDate <= date && date <= maxDate && isAllowed(cellState: cellState)
        }
        if let minDate = minAllowableDate {
            return date >= minDate && isAllowed(cellState: cellState)
        }
        if let maxDate = maxAllowableDate {
            return date <= maxDate && isAllowed(cellState: cellState)
        }
        return true
    }
    
    private func isAllowed(cellState: CellState) -> Bool {
        guard let departs = self.departs else { return true }
        
        switch departs {
        case .everyDay:
            return true
        case .specificDay:
            if let validDays = self.validDays {
                return validDays.contains(cellState.day)
            }
        case .unknown:
            return true
        }
        return true
    }
    
    private func isOutOfMonthDateMiddleCell(_ date: Date, cellSate: CellState) -> Bool {
        guard let firstDate = firstDate, let lastDate = lastDate else { return false }
        guard cellSate.dateBelongsTo != .thisMonth else { return false }
        
        if cellSate.dateBelongsTo == .previousMonthWithinBoundary {
            let activeMonthDate = date.adjust(.month, offset: 1)
            if firstDate.belongsToSomePrevMonth(of: activeMonthDate)
                && !lastDate.belongsToSomePrevMonth(of: activeMonthDate) {
                return true
            }
        } else if cellSate.dateBelongsTo == .followingMonthWithinBoundary {
            let activeMonthDate = date.adjust(.month, offset: -1)
            if lastDate.belongsToSomeNextMonth(of: activeMonthDate)
                && !firstDate.belongsToSomeNextMonth(of: activeMonthDate) {
                return true
            }
        }
        
        return false
    }
    
    public func positionTypeForDate(_ date: Date, cellSate: CellState) -> SelectionRangePosition {
        
        if let firstDate = firstDate, let lastDate = lastDate, !firstDate.compare(.isSameDay(as: lastDate)) {
            
            if date.compare(.isSameDay(as: firstDate)) && cellSate.dateBelongsTo == .thisMonth {
                return .left
            }
            
            if date.compare(.isSameDay(as: lastDate)) && cellSate.dateBelongsTo == .thisMonth {
                return .right
            }
            
            if (firstDate < date && date < lastDate && cellSate.dateBelongsTo == .thisMonth)
                || isOutOfMonthDateMiddleCell(date, cellSate: cellSate) {
                return .middle
            }
            
            return .none
        }
        
        if let firstDate = firstDate,
           date.compare(.isSameDay(as: firstDate)) && cellSate.dateBelongsTo == .thisMonth {
            return .full
        }
        
        return .none
    }
    
    public func onNewDateSelected(_ selectedDate: Date) {
        switch dateSelectionMode {
        case .range:
            if let firstDate = self.firstDate, let lastDate = self.lastDate {
                self.firstDate = nil
                self.lastDate = nil
                if selectedDate < firstDate || lastDate < selectedDate {
                    self.firstDate = selectedDate
                }
            } else if let firstDate = self.firstDate {
                if selectedDate.compare(.isSameDay(as: firstDate)) {
                    self.firstDate = nil
                } else if selectedDate < firstDate {
                    self.lastDate = firstDate
                    self.firstDate = selectedDate
                } else {
                    self.lastDate = selectedDate
                }
            } else {
                self.firstDate = selectedDate
            }
        case .single:
            if let firstDate = firstDate, selectedDate.compare(.isSameDay(as: firstDate)) {
                self.firstDate = nil
            } else {
                self.firstDate = selectedDate
            }
        }
        dateSelectionChangedCallback()
    }
}

fileprivate extension Date {
    func belongsToSomePrevMonth(of referenceDate: Date) -> Bool {
        return self < referenceDate && !compare(.isSameMonth(as: referenceDate))
    }
    
    func belongsToSomeNextMonth(of referenceDate: Date) -> Bool {
        return self > referenceDate && !compare(.isSameMonth(as: referenceDate))
    }
}
