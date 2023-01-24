//
//  CustomHeaderView.swift
//  eJobs
//
//  Created by Momen on 7/7/21.
//
import UIKit

public class CustomHeaderView: UIView {

    public let customLabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(customLabel)
        
        customLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        customLabel.textColor = .black
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        
        customLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        customLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        customLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0).isActive = true
        customLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40.0).isActive = true
    }
    
    public func config(title: String, textFont: UIFont, textColor: UIColor) {
        customLabel.text = title
        customLabel.font = textFont
        customLabel.textColor = textColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
