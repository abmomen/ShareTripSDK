//
//  DoubleInputCell.swift
//  TBBD
//
//  Created by TBBD on 3/17/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

struct DoubleInputData {
    let dotShown: Bool
    let inputTypeImage: String
    let firstPlaceholder: String
    let secondPlaceholder: String
    let firstInputValue: String?
    let secondInputValue: String?
}

class DoubleInputCell: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet private weak var topDotsImageView: UIImageView!
    @IBOutlet private weak var inputTypeImageView: UIImageView!
   
    @IBOutlet private weak var firstInputButton: UIButton!
    @IBOutlet private weak var secondInputButton: UIButton!
  
    @IBOutlet private weak var firstUnderlineView: UIView!
    @IBOutlet private weak var secondUnderlineView: UIView!

    //Private Properties
    private var cellIndexPath: IndexPath!
    private var callbackClosure: ((IndexPath, Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK:- Config
    func configure(indexPath: IndexPath, inputData: DoubleInputData, callbackClosure: ((_ cellIndexPath: IndexPath, Int) -> Void)?){
        
        cellIndexPath = indexPath
        self.callbackClosure = callbackClosure
        
        topDotsImageView.isHidden = !inputData.dotShown
        inputTypeImageView.image = UIImage(named: inputData.inputTypeImage)
        
        if let inputValue = inputData.firstInputValue {
            firstInputButton.setTitle(inputValue, for: .normal)
            firstInputButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            firstInputButton.setTitle(inputData.firstPlaceholder, for: .normal)
            firstInputButton.setTitleColor(UIColor.white.withAlphaComponent(0.6), for: .normal)
        }
        
        if let inputValue = inputData.secondInputValue {
            secondInputButton.setTitle(inputValue, for: .normal)
            secondInputButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            secondInputButton.setTitle(inputData.secondPlaceholder, for: .normal)
            secondInputButton.setTitleColor(UIColor.white.withAlphaComponent(0.6), for: .normal)
        }
    }
    
    @IBAction private func firstInputButtonTapped(_ sender: UIButton) {
        callbackClosure?(cellIndexPath, 0)
    }
    
    @IBAction private func secondInputButtonTapped(_ sender: UIButton) {
        callbackClosure?(cellIndexPath, 1)
    }
}
