//
//  PhoneNumberVerificationView.swift
//  ShareTrip
//
//  Created by ST-iOS on 9/14/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import UIKit

extension PhoneNumberVerificationView {
    class Callback {
        var didTapVerifyPhoneNumber: (String?) -> Void = { _ in }
        var didTapVerifyOTP: (String?) -> Void = { _ in }
        var didResetPhoneVerification: () -> Void = { }
    }
}

class PhoneNumberVerificationView: UIView, NibBased {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var resendButton: UIButton!
    @IBOutlet private weak var verifyButton: UIButton!
    @IBOutlet private weak var inputTextField: UITextField!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var instructionMessageLabel: UILabel!
    @IBOutlet private weak var errorMessageLabel: UILabel!
    @IBOutlet private weak var useAnotherNumberButton: UIButton!
    
    let callback = Callback()
    
    private var otp = ""
    private var phoneNumber = ""
    
    var otpExpiryTimeInSeconds: TimeInterval = 0 {
        didSet {
            let minutes = (otpExpiryTimeInSeconds / 60).rounded(.down)
            let seconds = otpExpiryTimeInSeconds.truncatingRemainder(dividingBy: 60).rounded()
            timerLabel.text = "\(Int(minutes)):\(Int(seconds))"
        }
    }
    
    private var timer: Timer? = nil {
        willSet {
            timer?.invalidate()
        }
    }
    
    private var isTimerRunning = false {
        didSet {
            handleResendButtonStatus()
        }
    }
    
    var inputType: InputType = .phone {
        didSet {
            updateView()
        }
    }
    
    func initilize() {
        timerLabel.isHidden = true
        resendButton.isHidden = true
        errorMessageLabel.isHidden = true
        inputTextField.tintColor = .black
        updateView()
    }
    
    private func updateView() {
        inputTextField.text = ""
        titleLabel.text = inputType.title
        verifyButton.layer.cornerRadius = 4.0
        verifyButton.backgroundColor = .appPrimary
        useAnotherNumberButton.isHidden = inputType == .phone
        inputTextField.placeholder = inputType.placeholderText
        instructionMessageLabel.text = inputType.instructionMessage
        inputTextField.textContentType = inputType.textContentType
    }
    
    private func handleResendButtonStatus() {
        resendButton.isHidden = isTimerRunning
        timerLabel.isHidden = !isTimerRunning
    }
    
    @IBAction private func didTapResendButton(_ sender: UIButton) {
        requetOTP(phoneNumber)
    }
    
    @IBAction private func textFieldEditingDidChanged(_ sender: UITextField) {
        switch inputType {
        case .phone:
            phoneNumber = sender.text ?? ""
        case .otp:
            otp = sender.text ?? ""
        }
    }
    
    @IBAction private func didTapVerifyButton(_ sender: UIButton) {
        switch inputType {
        case .phone:
            requetOTP(phoneNumber)
        case .otp:
            callback.didTapVerifyOTP(otp)
        }
    }
    
    @IBAction private func didTapUseAnotherNumber(_ sender: UIButton) {
        reset()
    }
    
    func reset() {
        inputType = .phone
        stopTimer()
        initilize()
        callback.didResetPhoneVerification()
    }
    
    func changeToOTPMode() {
        inputType = .otp
        startTimer()
    }
    
    private func requetOTP(_ phoneNumber: String?) {
        callback.didTapVerifyPhoneNumber(phoneNumber)
    }
    
    private func startTimer() {
        guard otpExpiryTimeInSeconds > 0 else { return }
        guard timer == nil else { return }
        isTimerRunning = true
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateTime),
            userInfo: nil,
            repeats: true
        )
    }
    
    private func stopTimer() {
        timer = nil
        otpExpiryTimeInSeconds = 0
        isTimerRunning = false
    }
    
    @objc
    private func updateTime() {
        otpExpiryTimeInSeconds -= 1
        if otpExpiryTimeInSeconds <= 0 {
            stopTimer()
        }
    }
}

extension PhoneNumberVerificationView {
    enum InputType {
        case phone
        case otp
        
        var placeholderText: String {
            switch self {
            case .phone:
                return "017XXXXXXXX"
            case .otp:
                return "789444"
            }
        }
        
        var title: String {
            switch self {
            case .phone:
                return "GPSTAR Verification!"
            case .otp:
                return "OTP Verification!"
            }
        }
        
        var instructionMessage: String {
            switch self {
            case .phone:
                return "Please enter your GPSTAR number for verification"
            case .otp:
                return "We have sent a 6-digit OTP to your GPSTAR number and registered email address"
            }
        }
        
        var textContentType: UITextContentType {
            switch self {
            case .phone:
                return .telephoneNumber
            case .otp:
                return .oneTimeCode
            }
        }
    }
}
