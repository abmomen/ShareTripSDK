//
//  DoubleButtonCell.swift
//  ShareTrip
//
//  Created by Mac on 8/28/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public struct DoubleButtonData {
    public let typeImage: String
    public let firstTitle: String
    public let secondTitle: String
    public let firstEnabled: Bool
    public let secondEnabled: Bool
    
    public init(typeImage: String, firstTitle: String, secondTitle: String, firstEnabled: Bool, secondEnabled: Bool) {
        self.typeImage = typeImage
        self.firstTitle = firstTitle
        self.secondTitle = secondTitle
        self.firstEnabled = firstEnabled
        self.secondEnabled = secondEnabled
    }
}

public protocol DoubleButtonCellDelegate: AnyObject   {
    func firstButtonTapped(indexPath: IndexPath)
    func secondButtonTapped(indexPath: IndexPath)
}

public class DoubleButtonCell: UITableViewCell {
    
    let typeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "circled-add")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let firstButton: UIButton = {
        let button = UIButton()
        button.setTitle("ADD CITY", for: .normal)
        button.tintColor = .white
        button.setBorder(cornerRadius: 4.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let secondButton: UIButton = {
        let button = UIButton()
        button.setTitle("REMOVE", for: .normal)
        button.tintColor = .white
        button.setBorder(cornerRadius: 4.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //Private Properties
    private var cellIndexPath: IndexPath!
    private weak var delegate: DoubleButtonCellDelegate?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(typeImageView)
        contentView.addSubview(firstButton)
        contentView.addSubview(secondButton)
        
        firstButton.addTarget(self, action: #selector(firstButtonTapped(_:)), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(secondButtonTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            typeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            typeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            typeImageView.widthAnchor.constraint(equalToConstant: 24.0),
            typeImageView.heightAnchor.constraint(equalToConstant: 24.0),
            
            firstButton.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 16.0),
            firstButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            firstButton.widthAnchor.constraint(equalToConstant: 112.0),
            firstButton.heightAnchor.constraint(equalToConstant: 36.0),
            
            secondButton.leadingAnchor.constraint(equalTo: firstButton.trailingAnchor, constant: 16.0),
            secondButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            secondButton.widthAnchor.constraint(equalToConstant: 112.0),
            secondButton.heightAnchor.constraint(equalToConstant: 36.0)
        ])
    }
    
    public func configure(buttonData: DoubleButtonData, indexPath: IndexPath, delegate: DoubleButtonCellDelegate) {
        self.cellIndexPath = indexPath
        self.delegate = delegate
        
        typeImageView.image = UIImage(named: buttonData.typeImage)
        
        firstButton.setTitle(buttonData.firstTitle, for: .normal)
        firstButton.isEnabled = buttonData.firstEnabled
        firstButton.alpha = buttonData.firstEnabled ? 1.0 : 0.6
        
        secondButton.setTitle(buttonData.secondTitle, for: .normal)
        secondButton.isEnabled = buttonData.secondEnabled
        secondButton.alpha = buttonData.secondEnabled ? 1.0 : 0.6
    }
    
    @objc
    func firstButtonTapped(_ sender: UIButton){
        delegate?.firstButtonTapped(indexPath: cellIndexPath)
    }
    
    @objc
    func secondButtonTapped(_ sender: UIButton){
        delegate?.secondButtonTapped(indexPath: cellIndexPath)
    }
}
