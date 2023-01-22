//
//  AirportInputCell.swift
//  TBBD
//
//  Created by TBBD on 11/24/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

struct AirportInputData {
    let dotShown: Bool
    let swapShown: Bool
    let inputTypeImage: String
    let firstPlaceholder: String
    let secondPlaceholder: String
    let firstInputValue: String?
    let secondInputValue: String?
}

class AirportInputCell: UITableViewCell {
    @IBOutlet weak var topDotsImageView: UIImageView!
    @IBOutlet weak var inputTypeImageView: UIImageView!

    @IBOutlet weak var firstInputButton: UIButton!
    @IBOutlet weak var secondInputButton: UIButton!
    
    @IBOutlet weak var firstUnderlineView: UIView!
    @IBOutlet weak var secondUnderlineView: UIView!
    @IBOutlet weak var swapButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var swapButton: UIButton!

    //Private Properties
    private var cellIndexPath: IndexPath!
    private var callbackClosure: ((IndexPath, Int) -> Void)?
    var swapCallbackClosure: ((IndexPath) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(indexPath: IndexPath, inputData: AirportInputData, callbackClosure: ((_ cellIndexPath: IndexPath, Int) -> Void)?){
        swapButton.layer.cornerRadius = 5
        cellIndexPath = indexPath
        self.callbackClosure = callbackClosure

        if inputData.swapShown {
            swapButton.isHidden = false
            swapButtonWidth.constant = 24.0
        } else {
            swapButton.isHidden = true
            swapButtonWidth.constant = 0.0
        }

        topDotsImageView.isHidden = !inputData.dotShown
        inputTypeImageView.image = UIImage.image(name: inputData.inputTypeImage)
        
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
    
    @IBAction func firstInputButtonTapped(_ sender: UIButton) {
        callbackClosure?(cellIndexPath, 0)
    }
    
    @IBAction func secondInputButtonTapped(_ sender: UIButton) {
        callbackClosure?(cellIndexPath, 1)
    }
    @IBAction func swapButtonTapped(_ sender: UIButton) {
        swapCallbackClosure?(cellIndexPath)
    }

}
