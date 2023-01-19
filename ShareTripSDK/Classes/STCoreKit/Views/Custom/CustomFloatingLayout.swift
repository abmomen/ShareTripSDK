//
//  CustomFloatingLayout.swift
//  ShareTrip
//
//  Created by Mac on 10/9/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import FloatingPanel

public class CustomFloatingLayout: FloatingPanelLayout {
    
    public init() { }
    
    public var position: FloatingPanelPosition {
        return .bottom
    }
    
    public var initialState: FloatingPanelState {
        return .tip
    }
    
    public var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .half: FloatingPanelLayoutAnchor(absoluteInset: UIScreen.main.bounds.size.height * 0.5, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 88.0, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
}
