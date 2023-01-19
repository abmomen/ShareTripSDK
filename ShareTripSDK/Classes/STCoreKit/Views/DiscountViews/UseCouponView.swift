//
//  UseCouponView.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 30/11/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public extension UseCouponView {
    class Callback {
        public var needsReload: () -> Void = { }
        public var didTapApplyCoupon: () -> Void = { }
        public var didSuccessApplyCoupon: () -> Void = { }
        public var didFailedApplyCoupon: (String) -> Void = { _ in }
        
        public var didTapVerifyButton: () -> Void = { }
        public var didVerifyPhoneNumber: () -> Void = { }
        public var needPhoneVerification: () -> Void = { }
        public var didVerifyOTP: () -> Void = { }
        public var didFailedGPStar: (String) -> Void = { _ in }
    }
}

public class UseCouponView: UIStackView, NibBased {
    @IBOutlet private weak var checkbox: GDCheckbox!
    @IBOutlet private weak var collapsibleContainer: UIView!
    @IBOutlet private weak var applyButton: UIButton!
    @IBOutlet private weak var couponTextField: NoSelectTextField!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var couponsContainerStackView: UIStackView!
    @IBOutlet private weak var couponSuggestionTitleHLC: NSLayoutConstraint!
    @IBOutlet private weak var couponSuggestionTitleLabel: UILabel!
    
    // MARK: - Properties
    public weak var delegate: DiscountOptionCollapsibleViewDelegate?
    
    public let callback = Callback()
    
    public var useCouponViewModel: UseCouponViewModel? {
        didSet {
            setupView()
        }
    }
    
    public var titleText = "" {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    public var subTitleText = "" {
        didSet {
            subtitleLabel.text = subTitleText
        }
    }
    
    private var couponSuggestionViews = [CouponSuggestionView?]()
    
    private func setupView() {
        setupAllCouponsView()
        callback.needsReload()
    }
    
    //MARK: - Coupons SuggestionViews
    private func setupAllCouponsView() {
        guard let useCouponViewModel = useCouponViewModel else { return }
        
        // Check if coupon pre-applied
        if useCouponViewModel.isCouponApplied {
            couponTextField.text = useCouponViewModel.appliedCoupon
            
            if useCouponViewModel.phoneVerificationRequired {
                guard useCouponViewModel.isGPStar else {
                    phoneVerificationView.inputType = .phone
                    setupMobileVerificationView()
                    return
                }
                
                guard useCouponViewModel.isOTPVerified else {
                    phoneVerificationView.inputType = .otp
                    setupMobileVerificationView()
                    return
                }
            }
            
            updateApplyButtonText()
            clearCouponContainerStackView()
            return
        }
        
        //Setup Coupons as usual
        setupCouponStackView()
        handleCouponNetworkResponses()
    }
    
    private func setupCouponStackView() {
        guard let useCouponViewModel = useCouponViewModel else { return }
        
        // Setup coupons
        couponSuggestionViews = []
        clearCouponContainerStackView()
        
        for index in 0..<useCouponViewModel.totalCouponsCount {
            couponSuggestionViews.append(createCouponView(index: index))
        }
        
        for couponView in couponSuggestionViews {
            guard let couponView = couponView else { continue }
            couponsContainerStackView.addArrangedSubview(couponView)
            couponView.callback.didSelectCouponView = handleCouponSelection(selectedIndex:)
        }
        
        updateApplyButtonText()
        updateApplyButtonText()
        couponsContainerStackView.isHidden = !(couponSuggestionViews.count > 0)
    }
    
    private func createCouponView(index: Int) -> CouponSuggestionView? {
        guard let useCouponViewModel = useCouponViewModel else { return nil }
        
        let availableCoupon = useCouponViewModel.getCoupon(for: index)
        let couponSuggestionView = CouponSuggestionView.instantiate()
        couponSuggestionView.setupView()
        couponSuggestionView.index = index
        couponSuggestionView.promotionalCoupon = availableCoupon
        return couponSuggestionView
    }
    
    //MARK: - Phone Verificaiton View
    private let phoneVerificationView = PhoneNumberVerificationView.instantiate()
    
    private func setupMobileVerificationView() {
        guard let useCouponViewModel = useCouponViewModel else { return }
        clearCouponContainerStackView()
        
        if useCouponViewModel.phoneVerificationRequired {
            phoneVerificationView.initilize()
            couponsContainerStackView.addArrangedSubview(phoneVerificationView)
            handlePhoneVerificationViewsCallbacks()
        }
        
        updateApplyButtonText()
    }
    
    private func resetViewMode() {
        couponTextField.text = ""
        useCouponViewModel?.couponViewMode = .apply
        phoneVerificationView.reset()
        useCouponViewModel?.resetAppliedCoupon()
        setupAllCouponsView()
        callback.needsReload()
    }
    
    //MARK: - IBActions
    @IBAction private func applyButtonTapped(_ sender: Any) {
        guard let useCouponViewModel = useCouponViewModel else { return }
        
        switch useCouponViewModel.couponViewMode {
        case .apply:
            applyCoupon()
            
        case .remove:
            resetViewMode()
        }
    }
    
    private func applyCoupon() {
        guard let useCouponViewModel = useCouponViewModel else { return }
        if let couponText = couponTextField.text {
            useCouponViewModel.selectedCouponString = couponText
        }
        useCouponViewModel.applyCoupon()
        callback.didTapApplyCoupon()
    }
    
    @IBAction private func onTapped(_ sender: Any) {
        delegate?.onDisCountOptionSelected(discountOptionView: self)
    }
    
    //MARK: - Actions
    private func clearCouponContainerStackView() {
        for view in couponsContainerStackView.arrangedSubviews { view.removeFromSuperview() }
    }
    
    private func updateApplyButtonText() {
        guard let useCouponViewModel = useCouponViewModel else { return }
        applyButton.setTitle(useCouponViewModel.couponViewMode.title, for: .normal)
        let height = (couponSuggestionViews.count > 0 && useCouponViewModel.couponViewMode == .apply) ? 18.0 : 0.0
        couponSuggestionTitleHLC.constant = height
    }
    
    private func handleCouponSelection(selectedIndex: Int) {
        useCouponViewModel?.selectedCouponIndex = selectedIndex
        handleBoderColor()
        autoFillCouponTextField()
    }
    
    private func handleBoderColor() {
        couponSuggestionViews.forEach { couponView in
            couponView?.isSelected = useCouponViewModel?.selectedCouponIndex == couponView?.index
        }
        couponsContainerStackView.layoutSubviews()
    }
    
    private func autoFillCouponTextField() {
        let selectedCoupon = useCouponViewModel?.selectedCouponString
        couponTextField.text = selectedCoupon
    }
    
    public func initPhoneVerification() {
        guard let useCouponViewModel = useCouponViewModel else { return }
        
        if useCouponViewModel.phoneVerificationRequired {
            useCouponViewModel.couponViewMode = .remove
            setupView()
        }
    }
    
    private func handleCouponNetworkResponses() {
        useCouponViewModel?.callback.didSuccessApplyCoupon = {[weak self] in
            self?.callback.didSuccessApplyCoupon()
        }
        
        useCouponViewModel?.callback.didFailedApplyCoupon = {[weak self] error in
            self?.callback.didFailedApplyCoupon(error)
        }
        
        //For GPStar
        useCouponViewModel?.callback.needPhoneVerification = {[weak self] in
            self?.callback.needPhoneVerification()
        }
        
        useCouponViewModel?.callback.didVerifyPhoneNumber = {[weak self] in
            self?.callback.didVerifyPhoneNumber()
            let expirySeconds = self?.useCouponViewModel?.otpExpiryTimeInSeconds ?? 0
            self?.phoneVerificationView.otpExpiryTimeInSeconds = expirySeconds
            self?.phoneVerificationView.changeToOTPMode()
        }
        
        useCouponViewModel?.callback.didVerifyOTP = {[weak self] in
            self?.clearCouponContainerStackView()
            self?.callback.didVerifyOTP()
        }
        
        useCouponViewModel?.callback.didFailedGPStar = {[weak self] error in
            self?.callback.didFailedGPStar(error)
        }
    }
    
    //MARK: - GPStar Callbacks
    private func handlePhoneVerificationViewsCallbacks() {
        guard let useCouponViewModel = useCouponViewModel else { return }
        
        phoneVerificationView.callback.didTapVerifyPhoneNumber = {[weak self] phoneNumber in
            guard let phoneNumber = phoneNumber, phoneNumber.trim().isValidPhoneNumber() else {
                self?.callback.didFailedGPStar("Invalid Phone Number")
                return
            }
            useCouponViewModel.verifyGPStar(phoneNumber.trim())
            self?.callback.didTapVerifyButton()
        }
        
        phoneVerificationView.callback.didTapVerifyOTP = {[weak self] otp in
            guard let otp = otp, (otp.trim().isValidNumeric() && otp.count == 6) else {
                self?.callback.didFailedGPStar("OTP validation failed")
                return
            }
            useCouponViewModel.verifyOTP(otp.trim())
            self?.callback.didTapVerifyButton()
        }
        
        phoneVerificationView.callback.didResetPhoneVerification = {[weak self] in
            self?.callback.needsReload()
        }
    }
}

//MARK:- DiscountOptionCollapsibleView

extension UseCouponView: DiscountOptionCollapsibleView {
    public var discountAmount: Double {
        return 0
    }
    
    public var discountOptionType: DiscountOptionType {
        .useCoupon
    }
    
    public var title: String {
        return "I want to Use Coupon Code"
    }
    
    public var expanded: Bool {
        return !collapsibleContainer.isHidden
    }
    
    public func expand() {
        checkbox.isOn = true
        collapsibleContainer.isHidden = false
    }
    
    public func collapse() {
        checkbox.isOn = false
        collapsibleContainer.isHidden = true
    }
}
