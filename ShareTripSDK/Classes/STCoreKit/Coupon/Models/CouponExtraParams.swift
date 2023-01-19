//
//  CouponExtraParams.swift
//  ShareTrip
//
//  Created by ST-iOS on 9/20/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

public struct CouponsServiceExtraParams {
    public let flighCouponExtraParams: FlightCouponsExtraParameters?
    public let hotelCouponExtraParams: HotelCouponsExtraParameters?
    public let packageCouponExtraParams: PackageCouponsExtraParams?
    
    public init(
        flighCouponExtraParams: FlightCouponsExtraParameters?,
        hotelCouponExtraParams: HotelCouponsExtraParameters?,
        packageCouponExtraParams: PackageCouponsExtraParams?
    ) {
        self.flighCouponExtraParams = flighCouponExtraParams
        self.hotelCouponExtraParams = hotelCouponExtraParams
        self.packageCouponExtraParams = packageCouponExtraParams
    }
}

public struct FlightCouponsExtraParameters {
    public let searchId: String?
    public let sequenceCode: String?
    
    public init(searchId: String?, sequenceCode: String?) {
        self.searchId = searchId
        self.sequenceCode = sequenceCode
    }
    
    public var requestParams: [String: Any] {
        var params = [String: Any]()
        params[Constants.APIParameterKey.searchId] = searchId
        params[Constants.APIParameterKey.sequenceCode] = sequenceCode
        return params
    }
}

//MARK: - Hotel Copouns Extra Parameters
public struct HotelCouponsExtraParameters {
    public let searchId: String
    public var propertyCode: String
    public let providerCode: String
    public let rooms: [Int]
    public let roomsSearchCode: String
    public let propertyRoomId: String
    
    public init(searchId: String, propertyCode: String, providerCode: String, rooms: [Int], roomsSearchCode: String, propertyRoomId: String) {
        self.searchId = searchId
        self.propertyCode = propertyCode
        self.providerCode = providerCode
        self.rooms = rooms
        self.roomsSearchCode = roomsSearchCode
        self.propertyRoomId = propertyRoomId
    }
    
    public var requestParams: [String: Any] {
        var params = [String: Any]()
        params[Constants.APIParameterKey.searchId] = searchId
        params[Constants.APIParameterKey.providerCode] = providerCode
        params[Constants.APIParameterKey.propertyCode] = propertyCode
        params[Constants.APIParameterKey.rooms] = rooms
        params[Constants.APIParameterKey.roomSearchCode] = roomsSearchCode
        params[Constants.APIParameterKey.propertyRoomId] = propertyRoomId
        return params
    }
}

//MARK: - Package Copouns Extra Parameters
public struct PackageCouponsExtraParams {
    public let productCode: String?
    
    public init(productCode: String?) {
        self.productCode = productCode
    }
    
    public var requestParams: [String: Any] {
        return [Constants.APIParameterKey.productCode: (productCode ?? "")]
    }
}

public struct PackageCouponParams {
    public let coupon: String
    public let serviceType: String
    public let deviceType: String
    public let extraParams: [String : Any]
    
    public init(coupon: String, serviceType: String, deviceType: String, extraParams: [String : Any]) {
        self.coupon = coupon
        self.serviceType = serviceType
        self.deviceType = deviceType
        self.extraParams = extraParams
    }
    
    public var params: [String: Any] {
        return [
            Constants.APIParameterKey.coupon : coupon,
            Constants.APIParameterKey.serviceType : serviceType,
            Constants.APIParameterKey.deviceType : deviceType,
            Constants.APIParameterKey.extraParams : extraParams
        ]
    }
}
