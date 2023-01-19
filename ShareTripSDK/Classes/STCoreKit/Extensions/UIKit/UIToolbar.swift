//
//  UIToolbar.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/5/22.
//

import UIKit

public extension UIToolbar {
    
    static func toolbarPicker(title: String, tag: Int, target: Any?, doneSelector: Selector?, cancelSelector: Selector?) -> UIToolbar {
        
        let toolbar = UIToolbar(frame:CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: 44))
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor.black
        toolbar.barTintColor = UIColor.paleGray
        toolbar.backgroundColor = UIColor.paleGray
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: target, action: doneSelector);
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)], for: .normal)
        doneButton.tag = tag
        
        let titleButton = UIBarButtonItem(title:title, style: .plain, target: nil, action: nil);
        titleButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.labelFontSize-5)], for: .normal)
        titleButton.isEnabled = false
        titleButton.tintColor = UIColor.lightGray
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: target, action: cancelSelector);
        cancelButton.tag = tag
        
        toolbar.setItems([cancelButton,spaceButton,titleButton,spaceButton,doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }
    
    static func toolbarPicker2(title: String, tag: Int, target: Any?, doneSelector: Selector?, cancelSelector: Selector?) -> UIToolbar {
        
        let toolbar = UIToolbar(frame:CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: 44))
        toolbar.autoresizingMask = .flexibleHeight
        toolbar.barStyle = .default
        toolbar.barTintColor = UIColor.paleGray
        toolbar.backgroundColor = UIColor.paleGray
        toolbar.isTranslucent = false
        var frame = toolbar.frame
        frame.size.height = 44.0
        toolbar.frame = frame
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: cancelSelector)
        cancelButton.tintColor = UIColor(hex: 0x030303, alpha: 1.0)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //a flexible space between the two buttons
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: doneSelector)
        doneButton.tintColor = UIColor(hex: 0x030303, alpha: 1.0)
        toolbar.items = [cancelButton, flexSpace, doneButton]
        
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }
    
    static func toolbarPicker(title: String, target: Any?, doneAction: Selector?) -> UIToolbar {
        
        let toolbar = UIToolbar(frame:CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: 44))
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor.black
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: target, action: doneAction)
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)], for: .normal)
        
        let titleButton = UIBarButtonItem(title:title, style: .plain, target: nil, action: nil);
        titleButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.labelFontSize-5)], for: .normal)
        titleButton.isEnabled = false
        titleButton.tintColor = UIColor.lightGray
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton, spaceButton, titleButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }
}
