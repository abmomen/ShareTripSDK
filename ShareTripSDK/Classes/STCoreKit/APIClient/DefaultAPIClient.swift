//
//  DefaultAPIClient.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/29/22.
//

import Alamofire

class DefaultAPIClient: APIClient {
    init() {}
    
    func submitTravelReviewCity(cityCode: String, wantToVisit: Bool, completion:@escaping (AFResult<BaseResponse>) -> Void) {
        performRequest(route: APIRouter.submitReviewCity(cityCode: cityCode, wantToVisit: wantToVisit), completion: completion)
    }
    
    //MARK:- Image Upload
    func uploadImage(imageData: Data, completion:@escaping (AFResult<Response<UploadFileResponse>>)->Void) -> UploadRequest {
        return uploadRequest(route: APIRouter.uploadFile(imageData: imageData), completion: completion)
    }
    
    //MARK:- Fetch payment gateways
    func fetchPaymentGateways(params: Parameters, completion:@escaping (AFResult<ResponseList<PaymentGateway>>) -> Void) {
        performRequest(route: APIRouter.paymentGateway(params: params), completion: completion)
    }
    
    func checkAppVersion(completion: @escaping (AFResult<Response<AppVersion>>) -> Void) {
        performRequest(route: APIRouter.appVersion, completion: completion)
    }
}

extension DefaultAPIClient {
    
    //MARK: - User Actions
    func login(email: String, password: String, completion:@escaping (AFResult<Response<STUser>>)->Void) {
        let params = [Constants.APIParameterKey.email: email, Constants.APIParameterKey.password: password]
        performRequest(route: UserAPIRouter.login(params: params), completion: completion)
    }
    
    func login(mobileNumber: String, password: String, completion:@escaping (AFResult<Response<STUser>>)->Void) {
        let params = [Constants.APIParameterKey.mobileNumber: mobileNumber, Constants.APIParameterKey.password: password]
        performRequest(route: UserAPIRouter.login(params: params), completion: completion)
    }
    
    func loginGoogle(token: String, completion:@escaping (AFResult<Response<STUser>>)->Void) {
        performRequest(route: UserAPIRouter.loginGoogle(token: token), completion: completion)
    }
    
    func loginFacebook(token: String, completion:@escaping (AFResult<Response<STUser>>)->Void) {
        performRequest(route: UserAPIRouter.loginFacebook(token: token), completion: completion)
    }
    
    func loginApple(token: String, completion:@escaping (AFResult<Response<STUser>>)->Void) {
        performRequest(route: UserAPIRouter.loginWithApple(identityToken: token), completion: completion)
    }
    
    func signup(params: Parameters, completion:@escaping (AFResult<Response<STUser>>)->Void) {
        performRequest(route: UserAPIRouter.signup(params: params), completion: completion)
    }
    
    func forgetPass(email: String, completion:@escaping (AFResult<BaseResponse>)->Void) {
        performRequest(route: UserAPIRouter.forgetPass(email: email), completion: completion)
    }
    
    func changePass(oldPass: String, newPass: String, completion:@escaping (AFResult<BaseResponse>)->Void) {
        performRequest(route: UserAPIRouter.changePassword(oldPass: oldPass, newPass: newPass), completion: completion)
    }
    
    func accountDeletionReasons(completion: @escaping (AFResult<Response<[AccountDeletionReason]>>) -> Void) {
        performRequest(route: UserAPIRouter.accountDeletionReasons, completion: completion)
    }
    
    func updateProfile(params: Parameters, completion:@escaping (AFResult<Response<STUserProfile>>) -> Void) {
        performRequest(route: UserAPIRouter.updateProfile(params: params), completion: completion)
    }
    
    func updateAvatar(imageData: Data, completion:@escaping (AFResult<Response<UploadFileResponse>>)->Void) -> UploadRequest {
        return uploadRequest(route: APIRouter.updateAvater(imageData: imageData), completion: completion)
    }
    
    func addQuickPick(params: Parameters, completion:@escaping (AFResult<BaseResponse>) -> Void) {
        performRequest(route: UserAPIRouter.quickPick(params: params), completion: completion)
    }
    
    func removeQuickPick(code: String, completion:@escaping (AFResult<BaseResponse>) -> Void) {
        let params = [Constants.APIParameterKey.code: code] as Parameters
        performRequest(route: UserAPIRouter.removeQuickPick(params: params), completion: completion)
    }
    
    func getUserInfo(completion:@escaping (AFResult<Response<STUserAccount>>)->Void) {
        performRequest(route: UserAPIRouter.userInfo, completion: completion)
    }
    
    func getSavedCardList(completion:@escaping (AFResult<Response<[SavedCardDetails]>>)->Void) {
        performRequest(route: UserAPIRouter.getSavedCardList, completion: completion)
    }
    
    func deleteSavedCard(cardUID: String, completion:@escaping (AFResult<Response<[SavedCardDetails]>>) -> Void) {
        let params: Parameters = [
            "uid": cardUID
        ]
        guard let data = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            let error = AppError.validationError("Request Invalid, can't encode")
            completion(.failure(.parameterEncoderFailed(reason: .encoderFailed(error: error))))
            return
        }
        performRequest(route: UserAPIRouter.deleteSavedCard(body: data), completion: completion)
    }
    
    func deleteUserAccount(reasonData: Data?, completion: @escaping (AFResult<BaseResponse>) -> Void) {
        performRequest(route: UserAPIRouter.accountDeletion(body: reasonData), completion: completion)
    }
}

