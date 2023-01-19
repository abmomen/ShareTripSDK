//
//  PopupInputView.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/4/22.
//

import UIKit

public protocol PopupInputViewDelegate: AnyObject {
    func crossButtonTapped()
}

open class PopupInputView: UIView {

    public lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .offWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.greyishBrown
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var crossButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"close-mono"), for: .normal)
        button.tintColor = UIColor.greyishBrown
        button.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            button.heightAnchor.constraint(equalToConstant: 24.0),
            button.widthAnchor.constraint(equalToConstant: 24.0)
        ]
        NSLayoutConstraint.activate(constraints)
        button.addTarget(self, action: #selector(self.crossButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Instance Properties
    
    /// Title of the card
    var title: String
    /// Height of the card
    public var height: CGFloat = 500.0
    /// Offset from bottom to display the card
    var offest: CGFloat = 0.0
    /// Delegate to receive cross button and done button tap event
    weak var delegate: PopupInputViewDelegate?
    /// Options to select
    
    // MARK: - Initializers / Deinitializers
    public init(title: String, height: CGFloat = 550.0, delegate: PopupInputViewDelegate? = nil) {
        self.title = title
        self.height = height
        self.delegate = delegate
        super.init(frame: .zero)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder: NSCoder not implemented")
    }
    
    deinit {
        STLog.info("\(Self.self) deinit")
    }
    
    // MARK: - Helper Methods
    private func setupView() {
        titleLabel.text = title
        backgroundColor = UIColor.black.withAlphaComponent(0.24)
        
        let screenWidth = UIScreen.main.bounds.size.width
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
        containerView.roundTopCorners(radius: 8.0, frame: frame)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        tapGesture.delegate = self
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
        
        addAllSubviews()
    }
    
    var containerViewBottomLC: NSLayoutConstraint!
    private func addAllSubviews() {
        addSubview(containerView)
        containerView.addSubview(crossButton)
        containerView.addSubview(titleLabel)
        
        // Intitialy move the card to the bottom of the screen
        containerViewBottomLC = containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: height)
        let constraints = [
            containerView.heightAnchor.constraint(equalToConstant: height),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerViewBottomLC!,
            
            crossButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16.0),
            crossButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            
            titleLabel.leadingAnchor.constraint(equalTo: crossButton.trailingAnchor, constant: 16.0),
            titleLabel.centerYAnchor.constraint(equalTo: crossButton.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    public func show() {
        layoutIfNeeded()
        containerViewBottomLC.constant = 0
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.layoutIfNeeded()
        })
    }
    
    public func hide() {
        containerViewBottomLC.constant = height
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.layoutIfNeeded()
        }) { [weak self] (finished) in
            guard finished else { return }
            self?.removeFromSuperview()
        }
    }
    
    
    // MARK:- Action Methods
    @objc
    private func viewTapped(_ sender: UIGestureRecognizer) {
        crossButtonTapped()
    }
    
    @objc
    public func crossButtonTapped(_ sender: UIButton? = nil) {
        delegate?.crossButtonTapped()
    }
}

// MARK: - UIGestureRecognizerDelegate
extension PopupInputView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view,
           touchedView.isDescendant(of: containerView) {
            return false
        }
        return true
    }
}

