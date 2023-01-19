//
//  SingleInputCell.swift
//  TBBD
//
//  Created by TBBD on 3/17/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public struct SingleInputData {
    public let inputTypeImage: String
    public let placeholder: String
    public let inputValue: String?
    
    public init(inputTypeImage: String, placeholder: String, inputValue: String?) {
        self.inputTypeImage = inputTypeImage
        self.placeholder = placeholder
        self.inputValue = inputValue
    }
}

public class SingleInputCell: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet public weak var topDotsImageView: UIImageView!
    @IBOutlet public weak var inputTypeImageView: UIImageView!
    @IBOutlet public weak var crossButton: UIButton!
    @IBOutlet public weak var inputButton: UIButton!
    @IBOutlet public weak var underlineView: UIView!
    @IBOutlet public weak var inputButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet public weak var inputButtonTrailingConstraint: NSLayoutConstraint!
    
    //Private Properties
    private var cellIndexPath: IndexPath!
    private var callbackClosure: ((IndexPath) -> Void)?
    private var crossCallbackClosure: ((IndexPath) -> Void)?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.crossButton.isHidden = true
    }

    public func configure(indexPath: IndexPath, singleInputData: SingleInputData, callbackClosure: ((_ cellIndexPath: IndexPath) -> Void)?, crossCallbackClosure: ((_ cellIndexPath: IndexPath) -> Void)? = nil){
    
        cellIndexPath = indexPath
        self.callbackClosure = callbackClosure
        self.crossCallbackClosure = crossCallbackClosure
        
        if indexPath.row == 0 {
            topDotsImageView.isHidden = true
        } else {
            topDotsImageView.isHidden = false
        }
        
        if singleInputData.inputValue == nil {
            inputButton.setTitle(singleInputData.placeholder, for: .normal)
            inputButton.setTitleColor(UIColor.white.withAlphaComponent(0.6), for: .normal)
        } else {
            inputButton.setTitle(singleInputData.inputValue!, for: .normal)
            inputButton.setTitleColor(UIColor.white, for: .normal)
        }
        
        inputTypeImageView.image = UIImage(named: singleInputData.inputTypeImage)?.tint(with: .white)
    }
    
    @IBAction private func inputButtonTapped(_ sender: UIButton) {
        callbackClosure?(cellIndexPath)
    }
    
    @IBAction private func crossButtonTapped(_ sender: UIButton) {
        crossCallbackClosure?(cellIndexPath)
    }
}
