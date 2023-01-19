//
//  CustomHeaderView.swift
//  eJobs
//
//  Created by Momen on 7/7/21.
//
import UIKit

public class CustomHeaderView: UITableViewHeaderFooterView {

    public let customLabel = UILabel()
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        customLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        customLabel.textColor = .black
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(customLabel)
        customLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        customLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        customLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0).isActive = true
        customLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40.0).isActive = true
    }
    
    public func config(title: String, textFont: UIFont, textColor: UIColor, backgroundColor: UIColor = .white) {
        customLabel.text = title
        customLabel.font = textFont
        customLabel.textColor = textColor
        contentView.backgroundColor = backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
