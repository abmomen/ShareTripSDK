//
//  UseCouponViewModel.swift
//  ShareTrip
//
//  Created by ST-iOS on 3/8/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

public extension UseCouponViewModel {
    class Callback {
        public var didSuccessApplyCoupon: () -> Void = { }
        public var didFailedApplyCoupon: (String) -> Void = { _ in }
        
        public var didVerifyPhoneNumber: () -> Void = { }
        public var needPhoneVerification: () -> Void = { }
        public var didVerifyOTP: () -> Void = { }
        public var didFailedGPStar: (String) -> Void = { _ in }
    }
}

public struct GPStarParams {
    public let verifiedMobileNumber: String?
    public let otp: String?
    
    public init(verifiedMobileNumber: String?, otp: String?) {
        self.verifiedMobileNumber = verifiedMobileNumber
        self.otp = otp
    }
}

public class UseCouponViewModel {
    private let serviceType: ServiceType
    private let availableCoupons: [PromotionalCoupon]
    private var appliedCouponResponse: CouponApplyResponse?
    
    public static let gpstarAlertTitle = "GPSTAR Verification!"
    public static let verifyPhoneMessage = "To avail this coupon, please verify your GPSTAR number"
    
    public init(serviceType: ServiceType, availableCoupons: [PromotionalCoupon]) {
        self.serviceType = serviceType
        self.availableCoupons = availableCoupons
    }
    
    public var selectedCouponString = ""
    public let callback = Callback()
    public var baseFare: Double = 0.0
    public var couponExtraParams = [String: Any]()
    
    public var selectedCouponIndex: Int? {
        didSet {
            guard let selectedCouponIndex = selectedCouponIndex else { return }
            guard selectedCouponIndex >= 0 && selectedCouponIndex < availableCoupons.count else {
                return
            }
            selectedCouponString = availableCoupons[selectedCouponIndex].coupon
        }
    }
    
    public var totalCouponsCount: Int {
        return availableCoupons.count
    }
    
    public var isCouponApplied: Bool {
        return appliedCouponResponse != nil
    }
    
    public var appliedCoupon: String {
        return selectedCouponString
    }
    
    public var selectedCouponGateways: [String] {
        guard let selectedCouponIndex = selectedCouponIndex else { return [] }
        guard selectedCouponIndex >= 0 && selectedCouponIndex < availableCoupons.count else {
            return []
        }
        return availableCoupons[selectedCouponIndex].gateway ?? []
    }
    
    public var gpstarParams: GPStarParams {
        return GPStarParams(
            verifiedMobileNumber: gpstarNumber,
            otp: otp
        )
    }
    
    public func resetAppliedCoupon() {
        gpstarResponse = nil
        appliedCouponResponse = nil
        isOTPVerified = false
    }
    
    public func getCoupon(for index: Int) -> PromotionalCoupon? {
        guard index >= 0 && index < availableCoupons.count else {
            return nil
        }
        return availableCoupons[index]
    }
    
    public var isWithDiscount: Bool {
        guard let appliedCouponResponse = appliedCouponResponse else { return false }
        
        //Check for gpstar
        guard phoneVerificationRequired else { return appliedCouponResponse.isWithDiscount }
        guard isVerifiedGPStarUser else { return false }
        return appliedCouponResponse.isWithDiscount
    }
    
    public var couponDiscount: Double {
        guard let couponResponse = appliedCouponResponse else { return 0 }
        var discountAmount: Double = 0.0
        
        switch couponResponse.discountType {
        case .flat:
            discountAmount = couponResponse.discount
            
        case .percentage:
            discountAmount = floor((baseFare * couponResponse.discount) / 100.0)
            
        default:
            break
        }
        
        //Check for gpstar
        guard phoneVerificationRequired else { return discountAmount }
        guard isVerifiedGPStarUser else { return 0.0 }
        return discountAmount
    }
    
    public var isVerifiedGPStarUser: Bool {
        return isGPStar && isOTPVerified
    }
    
    public var applyCouponRequestParams: [String: Any] {
        var params = [String: Any]()
        params[Constants.APIParameterKey.coupon] = selectedCouponString
        params[Constants.APIParameterKey.serviceType] = serviceType.rawValue
        params[Constants.APIParameterKey.deviceType] = "iOS"
        if couponExtraParams.count > 0 {
            params[Constants.APIParameterKey.extraParams] = couponExtraParams
        }
        return params
    }
    
    //MARK: - GPStar
    private var otp = ""
    private var gpstarNumber = ""
    public var isOTPVerified = false
    private var gpstarResponse: GPStarPhoneCheckResponse?
    
    public var isGPStar: Bool {
        guard let gpstarResponse else { return false }
        return gpstarResponse.success ?? false
    }
    
    public var otpExpiryTimeInSeconds: Double? {
        guard let gpstarResponse else { return 0 }
        return (gpstarResponse.otpExpirationInMin ?? 0) * 60
    }
    
    public var phoneVerificationRequired: Bool {
        return appliedCouponResponse?.isPhoneVerificationRequired ?? false
    }
    
    public var couponViewMode: CouponViewMode = .apply
    
    private func handleCouponApplyResponse() {
        if phoneVerificationRequired {
            callback.needPhoneVerification()
        } else {
            callback.didSuccessApplyCoupon()
        }
    }
    
    private func handleVerifyGPStarResponse() {
        if isGPStar {
            callback.didVerifyPhoneNumber()
        } else {
            callback.didFailedGPStar("Not a gpstar user")
        }
    }
    
    // MARK: - Network Requests
    public func applyCoupon() {
        CouponAPIClient().applyCoupon(params: applyCouponRequestParams) {[weak self] result in
            switch result {
            case .success(let response):
                if response.code == .success {
                    self?.appliedCouponResponse = response.response
                    self?.handleCouponApplyResponse()
                } else {
                    self?.resetAppliedCoupon()
                    self?.callback.didFailedApplyCoupon(response.message)
                }
                
            case .failure(let error):
                self?.resetAppliedCoupon()
                self?.callback.didFailedApplyCoupon(error.localizedDescription)
            }
        }
    }
    
    public func verifyGPStar(_ phoneNumber: String?) {
        self.gpstarNumber = phoneNumber ?? ""
        let request = GPStarRequest(mobileNumber: gpstarNumber, otp: nil)
        
        CouponAPIClient().checkGPStar(request: request) {[weak self] result in
            switch result {
            case .success(let response):
                if response.code == .success {
                    self?.gpstarResponse = response.response
                    self?.handleVerifyGPStarResponse()
                } else {
                    self?.gpstarResponse = nil
                    self?.callback.didFailedApplyCoupon(response.message)
                }
                
            case .failure(let error):
                self?.gpstarResponse = nil
                self?.callback.didFailedGPStar(error.localizedDescription)
            }
        }
    }
    
    public func verifyOTP(_ otp: String?) {
        self.otp = otp ?? ""
        let request = GPStarRequest(mobileNumber: gpstarNumber, otp: self.otp)
        
        CouponAPIClient().verifyOTP(request: request) {[weak self] result in
            switch result {
            case .success(let response):
                if response.code == .success {
                    self?.isOTPVerified = response.response?.success ?? false
                    self?.callback.didVerifyOTP()
                } else {
                    self?.isOTPVerified = false
                    self?.callback.didFailedGPStar(response.message)
                }
                
            case .failure(let error):
                self?.isOTPVerified = false
                self?.callback.didFailedGPStar(error.localizedDescription)
            }
        }
    }
}

public extension UseCouponViewModel {
    enum CouponViewMode {
        case apply
        case remove
        
        var title: String {
            switch self {
            case .apply:
                return "APPLY"
            case .remove:
                return "REMOVE"
            }
        }
    }
}
