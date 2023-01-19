//
//  CustomSystemDatePicker.swift
//  ShareTrip
//
//  Created by ST-iOS on 9/7/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import UIKit

class CustomSystemDatePicker: UIDatePicker {
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        if #available(iOS 13.4, *) {
            preferredDatePickerStyle = .wheels
        }
        
        calendar = Calendar(identifier: .gregorian)
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

class DoneCancelToolbar: UIToolbar {
    init() {
        super.init(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: 44))
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var doneAction: () -> Void = { }
    var cancelAction: () -> Void = { }
    
    private func setupView() {
        autoresizingMask = .flexibleHeight
        barStyle = .default
        barTintColor = UIColor.paleGray
        backgroundColor = UIColor.paleGray
        isTranslucent = false
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(_:)))
        cancelButton.tintColor = UIColor(hex: 0x030303, alpha: 1.0)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))
        doneButton.tintColor = UIColor(hex: 0x030303, alpha: 1.0)
        items = [cancelButton, flexSpace, doneButton]
    }
    
    @objc
    private func doneButtonTapped(_ button: UIBarButtonItem?) {
        doneAction()
    }
    
    @objc
    private func cancelButtonTapped(_ button: UIBarButtonItem?) {
        cancelAction()
    }
}
