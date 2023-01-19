//
//  FlightRouteCell.swift
//  ShareTrip
//
//  Created by Mac on 8/27/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

//MARK: - Flight Route Delegate
protocol FlightRouteDelegate: AnyObject {
    func flightRouteTypeChanged(type: FlightRouteType)
}

class FlightRouteCell: UITableViewCell {
    
    private let segmentedControl: MHSegmentedControl = {
        let control = MHSegmentedControl(frame: .zero)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private weak var delegate: FlightRouteDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.appPrimary
        selectionStyle = .none
        
        segmentedControl.segmentItems = FlightRouteType.allCases.map { return $0.title }
        segmentedControl.delegate = self
        contentView.addSubview(segmentedControl)
        
        segmentedControl.heightAnchor.constraint(equalToConstant: 44).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        segmentedControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func configure(selectedRoute: FlightRouteType, delegate: FlightRouteDelegate){
        segmentedControl.selectedIndex = selectedRoute.intValue
        self.delegate = delegate
    }
}

//MARK: - MHSegmentedControl Delegate
extension FlightRouteCell: MHSegmentedControlDelegate {
    func segmentedControlValueChanged(index: Int) {
        let routeType = FlightRouteType(intValue: index)
        delegate?.flightRouteTypeChanged(type: routeType)
    }
}
