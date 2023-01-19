//
//  DataPickerView.swift
//  TBBD
//
//  Created by Mac on 5/12/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class DataPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    public var data: [String]? {
        didSet {
            super.delegate = self
            super.dataSource = self
            self.reloadAllComponents()
        }
    }
    
    public var selectedValue: String {
        get {
            if let data = data, data.count > 0 {
                return data[selectedRow(inComponent: 0)]
            }
            return ""
        }
    }
    
    /** Get selected row if any row is selected, -1 otherwise */
    public var selectedRow: Int {
        return selectedRow(inComponent: 0)
    }
    
    //MARK:- Picker view data source & delegate
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if data != nil {
            return data!.count
        }
        return 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if data != nil {
            return data![row]
        }
        return ""
    }
}
