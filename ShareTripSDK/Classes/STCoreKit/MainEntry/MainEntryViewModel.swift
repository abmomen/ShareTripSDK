//
//  MainEntryViewModel.swift
//  ShareTrip
//
//  Created by Mac mini M1 on 23/8/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import GoogleSignIn
import AppAuth

enum FloatingViewType {
    case entry
    case loginEmail
    case register
    case forgot
    case resetPass
}

struct RegisterInputFields {
    let email: String
    let password: String
    let confirmPassword: String
    let mobileNumber: String?
    let referralCode: String?
}

extension MainEntryViewModel {
    class Callback {
        var didSuccessSignInWithGoogle: () -> Void = {  }
        var didFailedSignInWithGoogle: (String) -> Void = { _ in }
        
        var didSuccessSignInWithFacebook: () -> Void = { }
        var didFailedSignInWithFacebook: (String) -> Void = { _ in }
        
        var didSuccessSignInWithApple: () -> Void = { }
        var didFailedSignInWithApple: (String) -> Void = { _ in }
        
        var didSuccessSignInWithEmailAndPassword: () -> Void = { }
        var didFailedSignInWithEmailAndPassword: (String) -> Void = { _ in }
        
        var didSuccessSignUpWithEmailAndPassword: (String) -> Void = {_ in }
        var didFailedSignUpWithEmailAndPassword: (String) -> Void = { _ in }
        
        var didSuccessResetPassword: (String) -> Void = { _ in }
        var didFailedRestPassword: (String) -> Void = { _ in }
    }
}

class MainEntryViewModel {
    
    private(set) var isLoading = Observable<Bool>(false)
    let callback = Callback()
    
    private let analytics: AnalyticsManager = {
        let fae = FirebaseAnalyticsEngine()
        let manager = AnalyticsManager([fae])
        return manager
    }()
    
    
    // MARK: - SignIn With Facebook
    func signInWithFacebook(vc: UIViewController) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["email","public_profile"], from: vc, handler: { [weak self] result, error in
            guard let result = result else {
                STLog.error("No Result Found")
                return
            }
            
            if result.isCancelled {
                STLog.error("Cancelled \(String(describing: error?.localizedDescription))")
            } else if let error = error {
                STLog.error("Process error \(error.localizedDescription)")
            } else {
                if result.grantedPermissions.contains("email") {
                    self?.fetchProfile()
                } else {
                    self?.callback.didFailedSignInWithFacebook("You have to give email permission in order to login with facebook.")
                }
                STLog.info("Logged in")
            }
        })
    }
    
    // MARK: - SignIn With Google
    func signInWthGoogle(vc: UIViewController) {
        let clientId = Constants.App.googleClientID
        //let signInConfig = GIDConfiguration.init(clientID: clientId)
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { (signInResult, error) in
            if let error = error {
                STLog.error("\(error.localizedDescription)")
                return
            }

            self.isLoading.value = true
            DefaultAPIClient().loginGoogle(token: signInResult?.user.idToken?.tokenString ?? "") { [weak self] (result) in
                self?.isLoading.value = false
                switch result {
                case .success(let response):
                    if response.code == APIResponseCode.success, let userAuth = response.response {
                        let authToken = AuthToken(accessToken: userAuth.token, loginType: .google)
                        STUserSession.current.authToken = authToken
                        STUserSession.current.user = userAuth
                        DispatchQueue.main.async {
                            self?.callback.didSuccessSignInWithGoogle()
                        }
                    } else {
                        STLog.error("Error: \(response.code) -> \(response.message)")
                        self?.callback.didFailedSignInWithGoogle(response.message)
                    }
                case .failure(let error):
                    STLog.error(error.localizedDescription)
                    self?.callback.didFailedSignInWithGoogle("Something went wrong")
                }
            }
        }

        GIDSignIn.sharedInstance.disconnect { (error) in
            STLog.error("didDisconnectWith")
        }
    }
    
    // MARK: - SignIn Wih Apple
    func signInWithApple(with identityToken: String) {
        self.isLoading.value = true
        DefaultAPIClient().loginApple(token: identityToken) { [weak self] result in
            self?.isLoading.value = false
            
            switch result {
            case .success(let response):
                if response.code == .success, let userAuth = response.response {
                    let authToken = AuthToken(accessToken: userAuth.token, loginType: .apple)
                    STUserSession.current.authToken = authToken
                    STUserSession.current.user = userAuth
                    DispatchQueue.main.async {
                        self?.callback.didSuccessSignInWithApple()
                    }
                } else {
                    self?.callback.didFailedSignInWithApple(response.message)
                }
            case .failure(let error):
                STLog.error(error.localizedDescription)
                self?.callback.didFailedSignInWithApple(error.localizedDescription)
            }
        }
    }
    
    // MARK: - SignIn With Email & Password
    func loginWithEmailAndPassword(with email: String, and password: String) {
        guard !email.isReallyEmpty  else {
            self.callback.didFailedSignInWithEmailAndPassword("Please enter email address")
            return }
        guard email.validateEmailBetter() else {
            self.callback.didFailedSignInWithEmailAndPassword("Invalid email address")
            return }
        guard !password.isReallyEmpty  else {
            self.callback.didFailedSignInWithEmailAndPassword("Please enter your password")
            return }
        guard password.count > 7 else {
            self.callback.didFailedSignInWithEmailAndPassword("Password with min 8 characters")
            return }
        
        self.isLoading.value = true
        DefaultAPIClient().login(email: email, password: password) { [weak self] result in
            self?.isLoading.value = false
            
            switch result {
            case .success(let response):
                if response.code == .success, let userAuth = response.response {
                    let authToken = AuthToken(accessToken: userAuth.token, loginType: .email)
                    STUserSession.current.authToken = authToken
                    STUserSession.current.user = userAuth
                    DispatchQueue.main.async {
                        self?.callback.didSuccessSignInWithEmailAndPassword()
                    }
                } else {
                    self?.callback.didFailedSignInWithEmailAndPassword(response.message)
                }
            case .failure(let error):
                STLog.error(error.localizedDescription)
                self?.callback.didFailedSignInWithEmailAndPassword(error.localizedDescription)
            }
        }
    }
    
    // MARK: - SignUp With Email & Password
    func signUpWithEmailAndPassword(vc: UIViewController, fields: RegisterInputFields) {
        guard !fields.email.isReallyEmpty else {
            self.callback.didFailedSignUpWithEmailAndPassword("Please enter email address")
            return }
        guard fields.email.validateEmailBetter() else {
            self.callback.didFailedSignUpWithEmailAndPassword("Invalid email address")
            return }
        guard !fields.password.isReallyEmpty else {
            self.callback.didFailedSignUpWithEmailAndPassword("Please enter password")
            return }
        guard  fields.password.count > 7 else {
            self.callback.didFailedSignUpWithEmailAndPassword("Password with min 8 characters")
            return }
        guard  !fields.confirmPassword.isReallyEmpty else {
            self.callback.didFailedSignUpWithEmailAndPassword("Password Confirmation is required")
            return }
        guard fields.password == fields.confirmPassword else {
            self.callback.didFailedSignUpWithEmailAndPassword("Password did't match")
            return }
        guard fields.password.isValidPassword else {
            self.callback.didFailedSignUpWithEmailAndPassword("Password must contain at least 1 uppercase, 1 lowercase and 1 digit")
            return }
        guard  fields.mobileNumber?.isReallyEmpty ?? false || (!(fields.mobileNumber?.isReallyEmpty ?? false) && fields.mobileNumber?.isValidPhoneNumber() ?? false) else {
            self.callback.didFailedSignUpWithEmailAndPassword("Please enter a correct mobile number")
            return }
        
        var referralCode: String? = nil
        if let code = fields.referralCode, code.count > 0 {
            referralCode = code
        }
        var mobileNumber: String? = nil
        if let number = fields.mobileNumber, !number.isReallyEmpty {
            mobileNumber = number
        }
        
        var params = [
            Constants.APIParameterKey.email : fields.email,
            Constants.APIParameterKey.password : fields.password
        ]
        
        if let referralCode = referralCode {
            params[Constants.APIParameterKey.referralCode] = referralCode
        }
        
        if let mobileNumber = mobileNumber {
            params[Constants.APIParameterKey.mobileNumber] = mobileNumber
        }
        registerWithEmailAndPasswordAPICall(vc: vc, params: params)
    }
    
    private func registerWithEmailAndPasswordAPICall(vc: UIViewController, params: [String: Any]) {
        self.isLoading.value = true
        DefaultAPIClient().signup(params: params) { [weak self] result in
            switch result {
            case .success(let response):
                if response.code == APIResponseCode.success, let userAuth = response.response {
                    self?.analytics.log(UserRegistrationEvents.registrationSuccessfull)
                    self?.isLoading.value = false
                    
                    if userAuth.token.count == 0 {
                        vc.delay(0.15, closure: {
                            self?.callback.didSuccessSignUpWithEmailAndPassword("Please check your email to verify your email address to login. Thank you")
                        })
                    } else {
                        let authToken = AuthToken(accessToken: userAuth.token, loginType: .email)
                        STUserSession.current.authToken = authToken
                        STUserSession.current.user = userAuth
                        
                        vc.delay(0.15, closure: {
                            // FIXME: - Why Opening Scene When User Want to Register.
                            //self?.openMainScene()
                        })
                    }
                } else {
                    self?.analytics.log(UserRegistrationEvents.registrationFailed)
                    STLog.error("Error: \(response.code) -> \(response.message)")
                    self?.isLoading.value = false
                    vc.delay(0.15, closure: {
                        self?.callback.didFailedSignUpWithEmailAndPassword(response.message)
                    })
                }
            case .failure(let error):
                self?.analytics.log(UserRegistrationEvents.registrationFailed)
                STLog.error(error.localizedDescription)
                self?.isLoading.value = false
                vc.delay(0.15, closure: {
                    self?.callback.didFailedSignUpWithEmailAndPassword(error.localizedDescription)
                })
            }
        }
    }
    
    // MARK: - Forgot Password
    func resetPassword(with email: String) {
        guard !email.isReallyEmpty else {
            self.callback.didFailedRestPassword("Please enter email address")
            return }
        guard email.validateEmailBetter() else {
            self.callback.didFailedRestPassword("Invalid email address")
            return}
        self.isLoading.value = true
        
        DefaultAPIClient().forgetPass(email: email) { [weak self] result in
            self?.isLoading.value = false
            switch result {
            case .success(let response):
                if response.code == APIResponseCode.success {
                    DispatchQueue.main.async {
                        self?.callback.didSuccessResetPassword(response.message)
                    }
                } else {
                    STLog.error("Error: \(response.code) -> \(response.message)")
                    self?.callback.didFailedRestPassword(response.message)
                }
            case .failure(let error):
                STLog.error(error.localizedDescription)
                self?.callback.didFailedRestPassword(error.localizedDescription)
            }
        }
    }
    
    private func fetchProfile() {
        let parameters = ["fields" : "email, first_name, last_name, picture.type(large)"]
        GraphRequest(graphPath: "me", parameters: parameters).start(completion: { [weak self] (connection, result, error) in
            if let error = error {
                STLog.error(error.localizedDescription)
                self?.callback.didFailedSignInWithFacebook(error.localizedDescription)
                return
            }
            
            guard let tokenString = AccessToken.current?.tokenString else {
                STLog.error("Failed to fetch AccessToken")
                self?.callback.didFailedSignInWithFacebook("Failed to fetch profile information")
                return
            }
            
            if let dictionary = result as? NSDictionary {
                STLog.info(dictionary)
            }
            
            self?.isLoading.value = true
            DefaultAPIClient().loginFacebook(token: tokenString) { [weak self] (result) in
                self?.isLoading.value = false
                switch result {
                case .success(let response):
                    if response.code == APIResponseCode.success, let userAuth = response.response {
                        let authToken = AuthToken(accessToken: userAuth.token, loginType: .facebook)
                        STUserSession.current.authToken = authToken
                        STUserSession.current.user = userAuth
                        
                        DispatchQueue.main.async {
                            self?.callback.didSuccessSignInWithFacebook()
                        }
                    } else {
                        STLog.error("Error: \(response.code) -> \(response.message)")
                        self?.callback.didFailedSignInWithFacebook(response.message)
                    }
                case .failure(let error):
                    STLog.error(error.localizedDescription)
                    self?.callback.didFailedSignInWithFacebook(error.localizedDescription)
                }
            }
        })
    }
}
