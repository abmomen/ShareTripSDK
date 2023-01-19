//
//  CancellationAlertView.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/4/22.
//

import UIKit

public class CancellationAlertView: UIView {
    
    private var shouldSetupConstraints = true
    
    public var callbackClosure: ((Bool?) -> Void)?
    
    let contentView = UIView()
    let titleLabel = UILabel()
    let messageTextView = UITextView()
    let checkbox = GDCheckbox()
    let checkmarkLabel = UILabel()
    let yesButton = UIButton()
    let noButton = UIButton()
    
   //MARK:- initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // initWithFrame to init view from code
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // Our own initializer, that may have the data for the view in arguments
    convenience init() {
        self.init(frame: .zero)
        
    }
    
    //MARK:- SetupView
    private func setupView() {
        backgroundColor = UIColor(white: 0.25, alpha: 0.25)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 4.0
        contentView.clipsToBounds = true
        
        titleLabel.text = "Are you sure to cancel your booking?"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        
        //messageTextView
        let attributedString = NSMutableAttributedString(string: "Please read the Cancellation Policy before cancel the booking.\n")
        
        let attributes0: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor(hex: 0x666666)]
        attributedString.addAttributes(attributes0, range: NSRange(location: 0, length: 16))
        
        let attributes1: [NSAttributedString.Key : Any] = [ .foregroundColor:  UIColor(hex: 0x2a8cff),
                                                            .link: "CancellationPolicyLink"]
        attributedString.addAttributes(attributes1, range: NSRange(location: 16, length: 19))
        
        let attributes2: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor(hex: 0x666666)]
        attributedString.addAttributes(attributes2, range: NSRange(location: 35, length: 27))
        
        messageTextView.attributedText = attributedString
        messageTextView.isEditable = false
        messageTextView.isSelectable = true
        messageTextView.delegate = self
        messageTextView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        messageTextView.sizeToFit()
        messageTextView.isScrollEnabled = false
        
        //checkbox
        checkbox.checkColor = .white
        checkbox.checkWidth = 3.0
        checkbox.containerColor = UIColor.blueGray
        checkbox.containerFillColor = UIColor.appPrimary
        checkbox.containerWidth = 2.0
        checkbox.isCircular = false
        checkbox.isRadiobox = false
        checkbox.isSquare = false
        checkbox.shouldAnimate = true
        checkbox.shouldFillContainer = true
        checkbox.addTarget(self, action: #selector(checkboxValueChanged(_:)), for: .valueChanged)
        
        checkmarkLabel.text = "I’ve read the cancellation policy."
        checkmarkLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        checkmarkLabel.textColor = UIColor.black
        checkmarkLabel.numberOfLines = 0
        
        yesButton.isEnabled = false
        yesButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        noButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        yesButton.setTitle("YES", for: .normal)
        noButton.setTitle("NO", for: .normal)
        yesButton.setTitleColor(UIColor(hex: 0x666666), for: .normal)
        noButton.setTitleColor(UIColor(hex: 0x1882ff), for: .normal)
        yesButton.addTarget(self, action: #selector(yesButtonTapped(_:)), for: .touchUpInside)
        noButton.addTarget(self, action: #selector(noButtonTapped(_:)), for: .touchUpInside)
        
        // Setup UI
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkmarkLabel.translatesAutoresizingMaskIntoConstraints = false
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        noButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentView)
        addSubview(titleLabel)
        addSubview(messageTextView)
        addSubview(checkbox)
        addSubview(checkmarkLabel)
        addSubview(yesButton)
        addSubview(noButton)
        
        setNeedsUpdateConstraints()
    }
    
    public override func updateConstraints() {
        if shouldSetupConstraints {
            
            // AutoLayout constraints
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            let screenWidth = UIScreen.main.bounds.size.width
            let contentViewWidth = min(400.0, screenWidth * 0.9)
            contentView.widthAnchor.constraint(equalToConstant: contentViewWidth).isActive = true
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0).isActive = true
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32.0).isActive = true
            
            messageTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
            messageTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
            messageTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0).isActive = true
            
            checkbox.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: 16.0).isActive = true
            checkbox.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
            checkbox.widthAnchor.constraint(equalToConstant: 22.0).isActive = true
            checkbox.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
            
            checkmarkLabel.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 8.0).isActive = true
            checkmarkLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
            checkmarkLabel.centerYAnchor.constraint(equalTo: checkbox.centerYAnchor).isActive = true
            
            noButton.topAnchor.constraint(equalTo: checkbox.bottomAnchor, constant: 30.0).isActive = true
            noButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0).isActive = true
            noButton.widthAnchor.constraint(equalToConstant: 56.0).isActive = true
            noButton.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
            
            yesButton.trailingAnchor.constraint(equalTo: noButton.leadingAnchor, constant: -16.0).isActive = true
            yesButton.centerYAnchor.constraint(equalTo: noButton.centerYAnchor).isActive = true
            yesButton.widthAnchor.constraint(equalToConstant: 56.0).isActive = true
            yesButton.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
            
            noButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24.0).isActive = true
            
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    func setYesButtonState(active: Bool){
        let textColor = active ? UIColor.reddish : UIColor(hex: 0x666666)
        yesButton.isEnabled = active
        yesButton.titleLabel?.font = active ? UIFont.systemFont(ofSize: 14, weight: .bold) : UIFont.systemFont(ofSize: 14, weight: .regular)
        yesButton.setTitleColor(textColor, for: .normal)
    }
    
    @objc
    private func checkboxValueChanged(_ sender: Any){
        setYesButtonState(active: checkbox.isOn)
    }
    
    @objc
    private func yesButtonTapped(_ sender: Any){
        callbackClosure?(true)
        setYesButtonState(active: false)
        checkbox.isOn = false
        self.removeFromSuperview()
    }
    
    @objc
    private func noButtonTapped(_ sender: Any){
        callbackClosure?(false)
        setYesButtonState(active: false)
        checkbox.isOn = false
        self.removeFromSuperview()
    }
}

//MARK:- UITextViewDelegate
extension CancellationAlertView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        callbackClosure?(nil)
        return false
    }
}

