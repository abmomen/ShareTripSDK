//
//  InputTextFieldCellData.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/1/22.
//

import UIKit

public struct InputTextFieldCellData: ConfigurableTableViewCellData {
    public let title: String
    public let text: String
    public let placeholder: String
    public let imageString: String
    public let keyboardType: UIKeyboardType
    public let textContenType: UITextContentType?
    public var state: ValidationState
    
    public init(
        title: String,
        text: String,
        placeholder: String,
        imageString: String,
        keyboardType: UIKeyboardType = .default,
        textContenType: UITextContentType? = nil,
        state: ValidationState = .normal
    ) {
        self.title = title
        self.text = text
        self.placeholder = placeholder
        self.imageString = imageString
        self.keyboardType = keyboardType
        self.textContenType = textContenType
        self.state = state
    }
}
