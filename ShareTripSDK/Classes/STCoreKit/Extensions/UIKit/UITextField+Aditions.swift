//
//  UITextField+Aditions.swift
//  TBBD
//
//  Created by Mac on 5/15/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public extension UITextField {
    
    func addDoneToolbar(){
        let toolbar = UIToolbar(frame:CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: 44))
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor.black
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.resignFirstResponder))
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)], for: .normal)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        self.inputAccessoryView = toolbar
    }
    
    func setRightImageView(imageLink: String, tintColor: UIColor, frame: CGRect? = nil){
        let imageView = UIImageView(image: UIImage(named: imageLink))
        
        if let frame = frame {
            imageView.frame = frame
        }
        
        imageView.contentMode = UIView.ContentMode.center
        rightView = imageView
        rightView?.tintColor = tintColor
        rightViewMode = .always
    }
}
