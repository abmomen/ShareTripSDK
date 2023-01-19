//
//  MHSegmentedControl.swift
//  ShareTrip
//
//  Created by Mac on 8/27/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

protocol MHSegmentedControlDelegate: AnyObject {
    func segmentedControlValueChanged(index: Int)
}

class MHSegmentedControl: UIView {
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.backgroundColor = .clear
        control.tintColor = .clear
        if #available(iOS 13.0, *) {
            control.selectedSegmentTintColor = .clear
        }
        control.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)
            ], for: .normal)
        
        control.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            NSAttributedString.Key.foregroundColor: UIColor.white
            ], for: .selected)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let padding: CGFloat = 8.0
    
    var segmentItems: [String] = ["ONE", "TWO", "THREE"] {
        didSet {
            guard segmentItems.count > 0 else { return }
            setupSegmentItems()
            bottomBarWidthAnchor?.isActive = false
            bottomBarWidthAnchor = bottomBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentItems.count), constant: -2*padding)
            bottomBarWidthAnchor?.isActive = true
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            segmentedControl.selectedSegmentIndex = selectedIndex
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
                guard let self = self else { return }
                let originX = self.padding + (self.segmentedControl.frame.width / CGFloat(self.segmentItems.count)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
               self.bottomBar.frame.origin.x = originX
            }
        }
    }
    
    var bottomBarWidthAnchor: NSLayoutConstraint?
    weak var delegate: MHSegmentedControlDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(segmentedControl)
        addSubview(bottomBar)
        
        //segmentedControl.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.App.edgeConstant).isActive = true
        //segmentedControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.App.edgeConstant).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: topAnchor).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        bottomBar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        bottomBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
        bottomBarWidthAnchor = bottomBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentItems.count))
        bottomBarWidthAnchor?.isActive = true
        
        setupSegmentItems()
    }
    
    private func setupSegmentItems() {
        segmentedControl.removeAllSegments()
        for (index, value) in segmentItems.enumerated() {
            segmentedControl.insertSegment(withTitle: value, at: index, animated: false)
        }
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {

        UIView.animate(withDuration: 0.3) {
            let originX = self.padding + (self.segmentedControl.frame.width / CGFloat(self.segmentItems.count)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
            self.bottomBar.frame.origin.x = originX
        }
        delegate?.segmentedControlValueChanged(index: sender.selectedSegmentIndex)
    }
}
