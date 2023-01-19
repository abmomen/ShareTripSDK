//
//  PlaceholderView.swift
//  TBBD
//
//  Created by TBBD on 3/27/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit
import Kingfisher

public class PlaceholderView: UIView {
    
    private var shouldSetupConstraints = true
    
    let placeholderImageView = UIImageView(image: UIImage(named: "placeholder-mono"))

   //MARK:- initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // Our own initializer, that may have the data for the view in arguments
    convenience init() {
        self.init(frame: .zero)
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderImageView)
    }
    
    public override func updateConstraints() {
        if shouldSetupConstraints {
            placeholderImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            placeholderImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            placeholderImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
            placeholderImageView.heightAnchor.constraint(equalTo:  placeholderImageView.widthAnchor, multiplier: 1).isActive = true
            
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
}

extension PlaceholderView: Placeholder { /* Just leave it empty */}
