//
//  JTDateCell.swift
//  ConfigurableCalendar
//
//  Created by Sharetrip-iOS on 02/03/2020.
//  Copyright © 2020 TBBD. All rights reserved.
//

import UIKit
import JTAppleCalendar

public class JTDateCell: JTACDayCell {
    
    @IBOutlet private weak var leftView: UIView!
    @IBOutlet private weak var rightView: UIView!
    @IBOutlet private weak var selectedView: UIView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var todayLabel: UILabel!
    
    @IBOutlet private weak var indicatorView: UIView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(cellState: CellState, valid: Bool, selectedPosition: SelectionRangePosition) {
        if cellState.dateBelongsTo != .thisMonth {
            showHideAll(hide: true)
            handleCellSelection(selectedPosition: selectedPosition)
        } else {
            showHideAll(hide: false)
            dateLabel.text = cellState.text
            handleCellTextColor(for: cellState, valid: valid, selectedPosition: selectedPosition)
            handleCellSelection(selectedPosition: selectedPosition)
            todayLabel.isHidden = !(cellState.date.compare(.isSameDay(as: Date())) && selectedPosition == .none)
        }
    }
    
    public func showIndicatorView(cellState: CellState, indicator: IndicatorType) {
        guard !cellState.date.compare(.isSameDay(as: Date())) &&
                cellState.dateBelongsTo == .thisMonth else {
            indicatorView.isHidden = true
            return
        }
        
        indicatorView.isHidden = false
        indicatorView.backgroundColor = indicator.color
    }
    
    public func hideIndicatorView() {
        indicatorView.isHidden = true
    }
    
    private func showHideAll(hide: Bool) {
        if hide {
            dateLabel.isHidden = true
            todayLabel.isHidden = true
        } else {
            dateLabel.isHidden = false
            todayLabel.isHidden = false
        }
    }
    
    private func handleCellTextColor(for cellState: CellState, valid: Bool, selectedPosition: SelectionRangePosition) {
        if selectedPosition != .none {
            dateLabel.textColor = .white
        } else if cellState.dateBelongsTo == .thisMonth && valid {
            dateLabel.textColor = .black
        } else if cellState.dateBelongsTo != .thisMonth && valid {
            dateLabel.textColor = .darkGray
        } else {
            dateLabel.textColor = .lightGray
        }
    }
    
    private func handleCellSelection(selectedPosition: SelectionRangePosition) {
        switch selectedPosition {
        case .left:
            leftView.isHidden = true
            rightView.isHidden = false
            selectedView.isHidden = false
        case .middle:
            leftView.isHidden = false
            rightView.isHidden = false
            selectedView.isHidden = true
        case .right:
            leftView.isHidden = false
            rightView.isHidden = true
            selectedView.isHidden = false
        case .full:
            leftView.isHidden = true
            rightView.isHidden = true
            selectedView.isHidden = false
        case .none:
            leftView.isHidden = true
            rightView.isHidden = true
            selectedView.isHidden = true
        }
    }
}
