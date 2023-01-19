//
//  AccountService.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/29/22.
//

import Alamofire

public protocol AccountService {
    func updateProfile(params: Parameters, completion: @escaping (STUserAccount?)->Void)
    func addQuickPick(params: Parameters, completion: @escaping (STUserAccount?)->Void)
    func fetchUserInfo(completion: @escaping (STUserAccount?) -> Void)
    func uploadImageFile(imageData: Data, onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void) -> UploadRequest
}

public class AccountServiceDefault: AccountService {
    
    public init() { }
    
    public func fetchUserInfo(completion: @escaping (STUserAccount?) -> Void) {
        DefaultAPIClient().getUserInfo { (result) in
            switch result {
            case .success(let response):
                if response.code == APIResponseCode.success, let user = response.response {
                    STLog.info("User: \(user)")
                    STAppManager.shared.userAccount = user
                    completion(user)
                } else {
                    STLog.error("Response code: \(response.code) Error: \(response.message)")
                    completion(nil)
                }
            case .failure(let error):
                STLog.error(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    public func updateProfile(params: Parameters, completion: @escaping (STUserAccount?)->Void) {
        DefaultAPIClient().updateProfile(params: params) { (result) in
            switch result {
            case .success(let response):
                if response.code == APIResponseCode.success, let baseUser = response.response {
                    STLog.info("User: \(baseUser)")
                    STAppManager.shared.userAccount?.update(with: baseUser)
                    completion(STAppManager.shared.userAccount)
                } else {
                    STLog.error("Response code: \(response.code) Error: \(response.message)")
                    completion(nil)
                }
            case .failure(let error):
                STLog.error(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    public func addQuickPick(params: Parameters, completion: @escaping (STUserAccount?)->Void) {
        DefaultAPIClient().addQuickPick(params: params) { [weak self] (result) in
            switch result {
            case .success(let response):
                if response.code == APIResponseCode.success {
                    STLog.info("Update quick pick success. Fetching user info..")
                    self?.fetchUserInfo { user in
                        completion(user)
                    }
                } else {
                    STLog.error("Response code: \(response.code) Error: \(response.message)")
                    completion(nil)
                }
            case .failure(let error):
                STLog.error(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    public func uploadImageFile(imageData: Data, onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void) -> UploadRequest {
        let uploadRequest = DefaultAPIClient().uploadImage(imageData: imageData) { [weak self] result in
            switch result {
            case .success(let response):
                if response.code == APIResponseCode.success, let propertyResponse = response.response {
                    STLog.info("Upload success: \(propertyResponse.path)")
                    self?.fetchUserInfo { user in
                        onSuccess(propertyResponse.path)
                    }
                } else {
                    STLog.error("Response code: \(response.code), Error: \(response.message)")
                    onFailure(response.message)
                }
            case .failure(let error):
                STLog.error(error)
                onFailure(error.localizedDescription)
            }
        }
        return uploadRequest
    }
}
