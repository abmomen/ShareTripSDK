//
//  SingleInputTitleCell.swift
//  TBBD
//
//  Created by TBBD on 3/17/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public struct SingleInputTitleData {
    public let titleLabel: String
    public let inputTypeImage: String
    public let placeholder: String
    public let inputValue: String?
    
    public init(titleLabel: String, inputTypeImage: String, placeholder: String, inputValue: String?) {
        self.titleLabel = titleLabel
        self.inputTypeImage = inputTypeImage
        self.placeholder = placeholder
        self.inputValue = inputValue
    }
}

public class SingleInputTitleCell: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet private weak var topDotsImageView: UIImageView!
    @IBOutlet private weak var inputTypeImageView: UIImageView!
    @IBOutlet private weak var inputButton: UIButton!
    @IBOutlet private weak var underlineView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    //MARK:- Private Properties
    private var cellIndexPath: IndexPath!
    private var callbackClosure: ((IndexPath) -> Void)?
    private var crossCallbackClosure: ((IndexPath) -> Void)?
    private var inputTypeImageName = String()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(indexPath: IndexPath, singleInputData: SingleInputTitleData, callbackClosure: ((_ cellIndexPath: IndexPath) -> Void)?, crossCallbackClosure: ((_ cellIndexPath: IndexPath) -> Void)? = nil){
        titleLabel.text = singleInputData.titleLabel
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
        self.inputTypeImageName = singleInputData.inputTypeImage
        inputTypeImageView.image = UIImage(named: singleInputData.inputTypeImage)?.tint(with: .white)
    }
    
    public func setCellAttributeColor(){
        topDotsImageView.isHidden = true
        inputTypeImageView.image = UIImage(named: self.inputTypeImageName)?.tint(with: .black)
        titleLabel.textColor = UIColor.lightGray
        inputButton.setTitleColor(UIColor.black, for: .normal)
        underlineView.layer.backgroundColor = UIColor.blueGray.cgColor
    }
    
    @IBAction private func inputButtonTapped(_ sender: UIButton) {
        callbackClosure?(cellIndexPath)
    }
    
    @IBAction private func crossButtonTapped(_ sender: UIButton) {
        crossCallbackClosure?(cellIndexPath)
    }
}
