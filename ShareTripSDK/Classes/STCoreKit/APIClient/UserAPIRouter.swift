//
//  UserAPIRouter.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/29/22.
//

import Alamofire

enum UserAPIRouter: APIEndpoint {
    
    case login(params: Parameters)
    case loginGoogle(token: String)
    case loginFacebook(token: String)
    case loginWithApple(identityToken: String)
    
    case signup(params: Parameters)
    case forgetPass(email: String)
    case changePassword(oldPass: String, newPass: String)
    
    case userInfo
    case updateProfile(params: Parameters)
    
    case quickPick(params: Parameters)
    case removeQuickPick(params: Parameters)
    
    case getSavedCardList
    case deleteSavedCard(body: Data)
    
    case accountDeletionReasons
    case accountDeletion(body: Data?)
    
    // MARK: - HTTPMethod
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login, .loginGoogle, .loginFacebook, .loginWithApple:
            return .post
        case .signup, .forgetPass, .quickPick:
            return .post
        case .changePassword, .removeQuickPick:
            return .put
        case .userInfo, .getSavedCardList, .accountDeletionReasons:
            return .get
        case .updateProfile:
            return .patch
        case .deleteSavedCard, .accountDeletion:
            return .delete
        }
    }
    
    // MARK:- Path
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .loginGoogle:
            return "/auth/google"
        case .loginFacebook:
            return "/auth/facebook"
        case .loginWithApple:
            return "/auth/apple"
        case .signup:
            return "/auth/signup"
        case .forgetPass:
            return "/user/forgot-password"
        case .changePassword:
            return "/user/change-password"
        case .userInfo:
            return "/user/user-info"
        case .updateProfile:
            return "/user/update-profile"
            
        case .quickPick:
            return "/travel-details/add-new-traveler"
        case .removeQuickPick:
            return "/user/update-quick-pick"
        case .getSavedCardList:
            return "/user/list-card"
        case .deleteSavedCard:
            return "/user/remove-card"
        case .accountDeletionReasons:
            return "/user/delete-account-reasons"
        case .accountDeletion:
            return "/user/delete-my-account"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .login(let params):
            return params
        case .loginGoogle(let token):
            return [Constants.APIParameterKey.token: token]
        case .loginFacebook(let token):
            return [Constants.APIParameterKey.facebookToken: token]
        case .loginWithApple(let identityToken):
            return [Constants.APIParameterKey.appleToken: identityToken]
        case .signup(let params):
            return params
        case .forgetPass(let email):
            return [Constants.APIParameterKey.email: email]
        case .changePassword(let oldPass, let newPass):
            return [Constants.APIParameterKey.oldPassword: oldPass, Constants.APIParameterKey.newPassword: newPass]
        case .userInfo:
            return nil
        case .updateProfile(let params):
            return params
            
            
        case .quickPick(let params):
            return params
        case .removeQuickPick(let params):
            return params
        case .getSavedCardList, .deleteSavedCard, .accountDeletionReasons, .accountDeletion:
            return nil
        }
    }
    
    // MARK: - Image Data Tuples
    var imageDataTuple: (String, Data)? {
        switch self {
        default:
            return nil
        }
    }
    
    // MARK: - bodyData
    var bodyData: Data? {
        switch self {
        case .deleteSavedCard(let data):
            return data
        case .accountDeletion(let data):
            return data
        default:
            return nil
        }
    }
    
    //MARK: ContentType
    var contentType: ContentType? {
        switch self {
        default:
            return .json
        }
    }
}


