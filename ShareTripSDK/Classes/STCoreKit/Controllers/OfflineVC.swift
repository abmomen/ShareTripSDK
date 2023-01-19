//
//  OfflineVC.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/22/22.
//

import UIKit

public class OfflineVC: UIViewController {
    
    //MARK:- Initializer
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Property
    private lazy var noInternetImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "no-internet")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.greyishBrown
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK:- View's Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK:- Helpers
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(noInternetImageView)
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        
        titleLabel.text = "Oh no!"
        messageLabel.text = "No internet found. Check connectivity."
        
        NSLayoutConstraint.activate([
            noInternetImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60.0),
            noInternetImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noInternetImageView.widthAnchor.constraint(equalToConstant: 266.0),
            noInternetImageView.heightAnchor.constraint(equalToConstant: 266.0),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            titleLabel.topAnchor.constraint(equalTo: noInternetImageView.bottomAnchor, constant: 32.0),
            
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0)
        ])
    }
}

