//
//  SearchBar.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/4/22.
//


import UIKit

public class SearchBar: UISearchBar {
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        searchBarStyle = .minimal
        tintColor = .white
        returnKeyType = .search
        autocorrectionType = .no
        spellCheckingType = .no
        
        if let searchTF = searchField {
            
            searchTF.textColor = UIColor.white
            searchTF.borderStyle = .none
            searchTF.background = UIImage()
            searchTF.backgroundColor = UIColor(hex: 0xf8f8f8, alpha: 0.12)
            searchTF.clipsToBounds = true
            searchTF.layer.cornerRadius = 10.0
            searchTF.layer.borderWidth = 1.0
            searchTF.layer.borderColor = searchTF.backgroundColor!.cgColor
            
            //Cursor
            searchTF.tintColor = UIColor.gray
            
            //Placeholder
            let placeholderText = placeholder ?? "Search"
            searchTF.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7)])
            
            //White
            if let searchImageView = searchTF.leftView as? UIImageView {
                //white color
                searchImageView.image = searchImageView.image?.withRenderingMode(.alwaysTemplate)
                searchImageView.tintColor = UIColor.white
                searchImageView.contentMode = .left
                
                //Text Postion adjusted
                let searchImageSize = searchImageView.image!.size
                searchImageView.frame = CGRect(x: 0, y: 0, width: searchImageSize.width + 10, height: searchImageSize.height)
            }
            
            let clearSearchImageView = searchTF.rightView as? UIImageView
            clearSearchImageView?.image = clearSearchImageView?.image?.withRenderingMode(.alwaysTemplate)
            clearSearchImageView?.tintColor = UIColor.white
            
            //Clear Button
            if #available(iOS 11.0, *) {
                if let clearButton = searchTF.value(forKey: "_clearButton") as? UIButton {
                    clearButton.setImage(UIImage(named: "close-circle-mono")?.tint(with: .white), for: .normal)
                    clearButton.tintColor = .white
                }
            } else {
                if let clearButton = searchTF.value(forKey: "_clearButton") as? UIButton {
                    clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
                    clearButton.tintColor = .white
                } else {
                    for view in searchTF.subviews {
                        if let clearButton = view as? UIButton {
                            clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
                            clearButton.tintColor = .white
                        }
                    }
                }
            }
        }
    }
}

