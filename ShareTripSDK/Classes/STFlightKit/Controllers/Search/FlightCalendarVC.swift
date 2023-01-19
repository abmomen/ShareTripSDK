//
//  FlightCalendarVC.swift
//  ShareTrip
//
//  Created by Nazmul Islam on 30/3/20.
//  Copyright © 2020 TBBD IOS. All rights reserved.
//

import UIKit
import STCoreKit
import JTAppleCalendar

public class FlightCalendarVC: JTCalendarVC {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var calendarTopView: FlightCalendarTopView!
    private var calendarTopViewTopLC: NSLayoutConstraint!
    private let calendarTopViewHeight: CGFloat = 98
    
    // MARK: - Configuration Properties
    public var priceIndicator: FlightPriceIndicatorViewModel?
    
    public override func loadNibs() {
        let topView = FlightCalendarTopView.instantiate()
        self.calendarTopView = topView
        topView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topView)
        
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
        calendarTopViewTopLC = topView.topAnchor.constraint(equalTo: safeArea.topAnchor)
        calendarTopViewTopLC.isActive = true
        topView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: calendarTopViewHeight).isActive = true
        
        calendarView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        calendarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        calendarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        calendarView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        priceIndicator?.loadPriceIndicator { [weak self] in
            self?.onPriceIndicatorLoaded()
        }
    }
    
    private func onPriceIndicatorLoaded() {
        guard let priceIndicator = priceIndicator else { return }
        calendarTopView.updatePriceIndicatorLabels(priceIndicator: priceIndicator)
        calendarTopView.filterSwitch.isEnabled = true
        calendar.reloadData()
    }
    
    private var sildeAnimationEnabled = false
    
    public override func setupUI() {
        super.setupUI()
        
        if priceIndicator != nil {
            calendarTopViewTopLC.constant = 0
            calendarTopView.isHidden = false
            calendarTopView.filterSwitch.isOn = false
            calendarTopView.filterSwitch.isEnabled = false
        } else {
            calendarTopViewTopLC.constant = -calendarTopViewHeight
            calendarTopView.isHidden = true
        }
        
        calendarTopView.switchCallBack = { [weak self] isOn in
            self?.onTopViewSwitchToggled(isOn: isOn)
        }
        
        // Enable slide up/down annimation after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.sildeAnimationEnabled = true
        }
    }
    
    private func onTopViewSwitchToggled(isOn: Bool) {
        guard let priceIndicator = priceIndicator else { return }
        priceIndicator.filter(isOn)
        calendarTopView.updatePriceIndicatorLabels(priceIndicator: priceIndicator)
        calendar.reloadData()
    }
    
    private func indicatorType(for date: Date) -> IndicatorType? {
        guard let priceIndicator = priceIndicator else { return nil }
        guard let priceRangeType = priceIndicator.priceRangeType(for: date) else { return nil }
        
        switch priceRangeType {
        case .cheap:
            return .green
        case .moderate:
            return .yellow
        case .expensive:
            return .red
        case .unknown:
            return .unknown
        }
    }
    
    public override func configureCell(_ cell: JTACDayCell?, cellState: CellState, date: Date) {
        guard let cell = cell as? JTDateCell else { return }
        super.configureCell(cell, cellState: cellState, date: date)
        if let indicator = indicatorType(for: date) {
            cell.showIndicatorView(cellState: cellState, indicator: indicator)
        } else {
            cell.hideIndicatorView()
        }
    }
    
    private var animating: Bool = false
    
    private func slideupTopView() {
        guard !animating else { return }
        animating = true
        calendarTopViewTopLC.constant = -calendarTopViewHeight
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }) { [weak self] _ in
            self?.animating = false
        }
    }
    
    private func slideDownTopView() {
        guard !animating else { return }
        animating = true
        calendarTopViewTopLC.constant = 0
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }) { [weak self] _ in
            self?.animating = false
        }
    }
    
    public override func calendarDidScroll(_ calendar: JTACMonthView) {
        guard sildeAnimationEnabled else { return }
        guard priceIndicator != nil else { return }
        if calendar.panGestureRecognizer.translation(in: calendar.superview).y > 0 {
            slideDownTopView()
        } else {
            slideupTopView()
        }
    }
}
