//
//  MainEntryVC.swift
//  TBBD
//
//  Created by Mac on 6/13/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit
import PKHUD
import AuthenticationServices

public class AuthVC: UIViewController {
    
    @IBOutlet weak private var entryView: UIView!
    @IBOutlet weak private var loginEmailView: UIView!
    @IBOutlet weak private var registerView: UIView!
    @IBOutlet weak private var forgetPassView: UIView!
    @IBOutlet weak private var resetPassView: UIView!
    
    @IBOutlet weak private var entryViewBottomLC: NSLayoutConstraint!
    @IBOutlet weak private var loginEmailViewBottomLC: NSLayoutConstraint!
    @IBOutlet weak private var registerViewBottomLC: NSLayoutConstraint!
    @IBOutlet weak private var forgetPassViewBottomLC: NSLayoutConstraint!
    @IBOutlet weak private var resetPassViewBottomLC: NSLayoutConstraint!
    
    //NOTE: it's own name + it's super view short name + UI type
    
    //entryView
    @IBOutlet weak private var emailLoginButtonContainer: UIView!
    @IBOutlet weak private var facebookButtonContainerView: UIView!
    @IBOutlet weak private var googleButtonContainerView: UIView!
    @IBOutlet weak private var signInWithGoogleButton: UIButton!
    @IBOutlet weak private var appleSigninButtonCotainer: UIView!
    @IBOutlet weak private var appleSigninButtonContainerHLC: NSLayoutConstraint!
    @IBOutlet weak private var appleSignInButtonContainerTLC: NSLayoutConstraint!
    
    //loginEmailView
    @IBOutlet weak private var emailTFForLoginEmailView: UITextField!
    @IBOutlet weak private var passwordTFForLoginEmailView: UITextField!
    @IBOutlet weak private var passwordEyeIconForLoginEmailView: UIButton!
    @IBOutlet weak private var loginBtnForLoginEmailView: UIButton!
    
    //registerView
    @IBOutlet weak private var emailTFRegisterView: UITextField!
    @IBOutlet weak private var passwordTFRegisterView: UITextField!
    @IBOutlet weak private var passwordConfirmationTFRregisterView: UITextField!
    @IBOutlet weak private var phoneNumberTFRegisterView: UITextField!
    @IBOutlet weak private var inviteCodeTFRegisterView: UITextField!
    
    @IBOutlet weak private var signupBtnRegisterView: UIButton!
    @IBOutlet weak private var registerViewEyeIconForPassword: UIButton!
    @IBOutlet weak private var registerViewEyeIconForPasswordConfirmation: UIButton!
    
    //forgetPassView
    @IBOutlet weak private var emailTextFieldForgetPassView: UITextField!
    @IBOutlet weak private var resetPassBtnForgetPassView: UIButton!
    
    //resetPassView
    @IBOutlet weak private var newPasswordTFResetPassView: UITextField!
    @IBOutlet weak private var setPasswordBtnResetPassView: UIButton!
    
    private var currentFloatingViewType: FloatingViewType?
    private let viewModel = MainEntryViewModel()
    
    private let analytics: AnalyticsManager = {
        let fae = FirebaseAnalyticsEngine()
        let manager = AnalyticsManager([fae])
        return manager
    }()
    
    var firstLoad: Bool = true
    public weak var delegate: MainEntryVCDelegate?
    
    // MARK: - View's Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        handleNetworkResponse()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if firstLoad {
            firstLoad = false
            openFloatingView(.entry)
        }
    }
    
    private func handleNetworkResponse() {
        viewModel.callback.didSuccessSignInWithGoogle = { [weak self] in
            self?.openMainScene()
        }
        viewModel.callback.didFailedSignInWithGoogle = { [weak self] message in
            self?.showAlert(message: message, withTitle: "Failed to login")
        }
        
        viewModel.callback.didSuccessSignInWithFacebook = { [weak self] in
            self?.openMainScene()
        }
        viewModel.callback.didFailedSignInWithFacebook = { [weak self] message in
            self?.showAlert(message: message, withTitle: "Failed to login")
        }
        
        viewModel.callback.didSuccessSignInWithApple = { [weak self] in
            self?.openMainScene()
        }
        viewModel.callback.didFailedSignInWithApple = { [weak self] message in
            self?.showAlert(message: message, withTitle: "Failed to login")
        }
        
        viewModel.callback.didSuccessSignInWithEmailAndPassword = { [weak self] in
            self?.openMainScene()
        }
        viewModel.callback.didFailedSignInWithEmailAndPassword = { [weak self] message in
            self?.showAlert(message: message, withTitle: "Failed to login")
        }
        
        viewModel.callback.didSuccessSignUpWithEmailAndPassword = { [weak self] message in
            self?.showAlert(message: message)
            self?.closeFloatingViewBtnTapped(UIButton())
        }
        
        viewModel.callback.didFailedSignUpWithEmailAndPassword = { [weak self] message in
            self?.showAlert(message: message, withTitle: "Failed to sign up")
        }
        
        viewModel.callback.didSuccessResetPassword = { [weak self] message in
            self?.showAlert(message: message, withTitle: "Successful", handler: { _ in
                self?.cleanUserData(viewType: .forgot)
                self?.closeCurrentAndOpenFloatingView(.entry)
            })
        }
        viewModel.callback.didFailedRestPassword = { [weak self] message in
            self?.showAlert(message: message, withTitle: "Failed to process")
        }
        
        viewModel.isLoading.bindAndFire { isLoading in
            if isLoading {
                DispatchQueue.main.async {
                    HUD.show(.progress)
                }
            } else {
                DispatchQueue.main.async {
                    HUD.hide(animated: false)
                }
            }
        }
    }
    
    // MARK: - Sign In With Google
    @IBAction private func signInWithGoogleButtonTapped(_ sender: UIButton) {
        viewModel.signInWthGoogle(vc: self)
    }
    
    @IBAction private func closeFloatingViewBtnTapped(_ sender: Any) {
        cleanUserData()
        closeCurrentAndOpenFloatingView(.entry)
    }
    
    @IBAction private func openSignupBtnTapped(_ sender: Any) {
        cleanUserData()
        closeCurrentAndOpenFloatingView(.register)
    }
    
    @IBAction private func openLoginBtnTapped(_ sender: Any) {
        cleanUserData()
        closeCurrentAndOpenFloatingView(.entry)
    }
    
    @IBAction private func skipLoginBtnTapped(_ sender: Any) {
        STUserSession.current.clear()
        openMainScene()
    }
    
    @IBAction func textFieldIsEditingChangedForLoginView(_ sender: UITextField) {
        passwordEyeIconForLoginEmailView.isHidden = (sender.text ?? "").isReallyEmpty
        handleEyeIconButtonPress(passwordTFForLoginEmailView, passwordEyeIconForLoginEmailView)
    }
    
    @IBAction func textFieldIsEditingChangedForPassword(_ sender: UITextField) {
        registerViewEyeIconForPassword.isHidden = (sender.text ?? "").isReallyEmpty
        handleEyeIconButtonPress(passwordTFRegisterView, registerViewEyeIconForPassword)
    }
    
    @IBAction func textFieldIsEditionChangeForPasswordConfirmation(_ sender: UITextField) {
        registerViewEyeIconForPasswordConfirmation.isHidden = (sender.text ?? "").isReallyEmpty
        handleEyeIconButtonPress(passwordConfirmationTFRregisterView, registerViewEyeIconForPasswordConfirmation)
    }
    
    @IBAction private func loginViewEyeIconActionForPassword(_ sender: UIButton) {
        passwordTFForLoginEmailView.isSecureTextEntry.toggle()
        handleEyeIconButtonPress(passwordTFForLoginEmailView, passwordEyeIconForLoginEmailView)
    }
    
    @IBAction private func registerViewEyeIconActionForPassword(_ sender: UIButton) {
        passwordTFRegisterView.isSecureTextEntry.toggle()
        handleEyeIconButtonPress(passwordTFRegisterView, registerViewEyeIconForPassword)
    }
    
    @IBAction private func registerViewEyeIconActionForPasswordConfirmation(_ sender: UIButton) {
        passwordConfirmationTFRregisterView.isSecureTextEntry.toggle()
        handleEyeIconButtonPress(passwordConfirmationTFRregisterView, registerViewEyeIconForPasswordConfirmation)
    }

    private func handleEyeIconButtonPress(_ textField: UITextField, _ button: UIButton ) {
        if textField.isSecureTextEntry {
            if let image = UIImage(systemName: "eye.slash.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal) {
                button.setImage(image, for: .normal)
            }
        } else {
            if let image = UIImage(systemName: "eye.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal) {
                button.setImage(image, for: .normal)
            }
        }
    }
    
    // MARK: Entry View's Action
    @IBAction private func emailLoginBtn_entryViewTapped(_ sender: Any) {
        closeCurrentAndOpenFloatingView(.loginEmail)
    }
    
    // MARK: - Sign In with Facebook
    @IBAction private func fbLoginButtonTapped(_ sender: Any) {
        viewModel.signInWithFacebook(vc: self)
    }
    
    @objc private func handleAppleIdRequest(){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // MARK: - Login With Email and Password
    @IBAction private func loginBtn_loginEmailViewTapped(_ sender: Any) {
        guard let email = emailTFForLoginEmailView.text else { return }
        guard let password = passwordTFForLoginEmailView.text else { return }
        viewModel.loginWithEmailAndPassword(with: email, and: password)
    }
    
    @IBAction func forgotPass_loginEmailViewTapped(_ sender: Any) {
        STLog.error("forgotPass_loginEmailViewTapped")
        cleanUserData(viewType: .loginEmail)
        closeCurrentAndOpenFloatingView(.forgot)
    }
    
    // MARK: - Sign Up With Email Address
    @IBAction private func signupBtn_registerViewTapped(_ sender: Any) {
        guard let email = emailTFRegisterView.text else { return }
        guard let password = passwordTFRegisterView.text else { return }
        guard let confirmPassword = passwordConfirmationTFRregisterView.text else { return }
        guard let mobileNumber = phoneNumberTFRegisterView.text else { return }
        guard let code = inviteCodeTFRegisterView.text else { return }
        
        let fields = RegisterInputFields(email: email,
                                     password: password,
                                     confirmPassword: confirmPassword,
                                     mobileNumber: mobileNumber,
                                     referralCode: code)
        viewModel.signUpWithEmailAndPassword(vc: self, fields: fields)
    }
    
    // MARK: - Forgot Password View Action
    @IBAction private func resetPassBtn_forgetPassViewTapped(_ sender: Any) {
        guard let email = emailTextFieldForgetPassView.text else { return }
        viewModel.resetPassword(with: email)
    }
    
    // MARK: - Reset Password View Action
    @IBAction private func setPasswordBtn_resetPassViewTapped(_ sender: Any) {
        STLog.info("setPasswordBtn_resetPassViewTapped")
    }
    
    // MARK: - Navigation
    private func setupViews() {
        entryViewBottomLC.constant = entryView.bounds.size.height * (-1)
        loginEmailViewBottomLC.constant = loginEmailView.bounds.size.height * (-1)
        registerViewBottomLC.constant = registerView.bounds.size.height * (-1)
        forgetPassViewBottomLC.constant = forgetPassView.bounds.size.height * (-1)
        resetPassViewBottomLC.constant = resetPassView.bounds.size.height * (-1)
        
        entryView.isHidden = true
        loginEmailView.isHidden = true
        registerView.isHidden = true
        forgetPassView.isHidden = true
        resetPassView.isHidden = true
        registerViewEyeIconForPassword.isHidden = true
        registerViewEyeIconForPasswordConfirmation.isHidden = true
        
        setupSignButtons()
    }
    
    private func setupSignButtons() {
        setupButtonsLook(buttonContainerView: facebookButtonContainerView)
        setupButtonsLook(buttonContainerView: googleButtonContainerView)
        setupButtonsLook(buttonContainerView: emailLoginButtonContainer)
        setUpSignInAppleButton()
    }
    
    // MARK: - Apple SignIn Button Setup
    private func setUpSignInAppleButton() {
        let authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .continue, authorizationButtonStyle: .black)
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        authorizationButton.cornerRadius = 3.0
        setupButtonsLook(buttonContainerView: appleSigninButtonCotainer)
        self.appleSigninButtonCotainer.addSubview(authorizationButton)
        
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorizationButton.leadingAnchor.constraint(equalTo: appleSigninButtonCotainer.leadingAnchor),
            authorizationButton.trailingAnchor.constraint(equalTo: appleSigninButtonCotainer.trailingAnchor),
            authorizationButton.topAnchor.constraint(equalTo: appleSigninButtonCotainer.topAnchor),
            authorizationButton.bottomAnchor.constraint(equalTo: appleSigninButtonCotainer.bottomAnchor)
        ])
        
        appleSigninButtonContainerHLC.constant = 44.0
        appleSignInButtonContainerTLC.constant = 16.0
    }
    
    private func setupButtonsLook(buttonContainerView: UIView) {
        buttonContainerView.layer.borderWidth = 0.2
        buttonContainerView.layer.cornerRadius = 3.0
        buttonContainerView.layer.borderColor = UIColor.gray.cgColor
        buttonContainerView.clipsToBounds = true
        buttonContainerView.addZeplinShadow(color: .gray)
    }
    
    private func closeFloatingView(_ viewType: FloatingViewType, animation: Bool = true){
        view.endEditing(true)
        
        switch viewType {
        case .entry:
            entryViewBottomLC.constant = entryView.bounds.size.height * (-1)
        case .loginEmail:
            loginEmailViewBottomLC.constant = loginEmailView.bounds.size.height * (-1)
        case .register:
            registerViewBottomLC.constant = registerView.bounds.size.height * (-1)
        case .forgot:
            forgetPassViewBottomLC.constant = forgetPassView.bounds.size.height * (-1)
        case .resetPass:
            resetPassViewBottomLC.constant = resetPassView.bounds.size.height * (-1)
        }
        
        currentFloatingViewType = nil
        
        if animation {
            
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            }) { [weak self] (success) in
                guard let strongSelf = self else { return }
                if success {
                    strongSelf.updateFloatingViewVisibility(viewType: viewType, hide: true)
                }
            }
        } else {
            view.layoutIfNeeded()
            updateFloatingViewVisibility(viewType: viewType, hide: true)
        }
    }
    
    private func openFloatingView(_ viewType: FloatingViewType, animation: Bool = true){
        switch viewType {
        case .entry:
            entryViewBottomLC.constant = 0
        case .loginEmail:
            loginEmailViewBottomLC.constant = 0
        case .register:
            registerViewBottomLC.constant = 0
        case .forgot:
            forgetPassViewBottomLC.constant = 0
        case .resetPass:
            resetPassViewBottomLC.constant = 0
        }
        
        currentFloatingViewType = viewType
        updateFloatingViewVisibility(viewType: viewType, hide: false)
        
        if animation {
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {
            view.layoutIfNeeded()
        }
    }
    
    private func closeCurrentAndOpenFloatingView(_ viewType: FloatingViewType){
        if let currentFloatingViewType = currentFloatingViewType {
            guard currentFloatingViewType != viewType else { return }
            closeFloatingView(currentFloatingViewType)
        }
        
        openFloatingView(viewType)
    }
    
    private func updateFloatingViewVisibility(viewType: FloatingViewType, hide: Bool){
        switch viewType {
        case .entry:
            entryView.isHidden = hide
        case .loginEmail:
            loginEmailView.isHidden = hide
        case .register:
            registerView.isHidden = hide
        case .forgot:
            forgetPassView.isHidden = hide
        case .resetPass:
            resetPassView.isHidden = hide
        }
    }
    
    private func cleanUserData(viewType: FloatingViewType? = nil) {
        if let viewType = viewType {
            switch viewType {
            case .entry:
                break
            case .loginEmail:
                emailTFForLoginEmailView.text = nil
                passwordTFForLoginEmailView.text = nil
                passwordEyeIconForLoginEmailView.isHidden = true
                passwordTFForLoginEmailView.isSecureTextEntry = true
            case .register:
                emailTFRegisterView.text = nil
                passwordTFRegisterView.text = nil
                passwordConfirmationTFRregisterView.text = nil
                phoneNumberTFRegisterView.text = nil
                inviteCodeTFRegisterView.text = nil
                registerViewEyeIconForPassword.isHidden = true
                registerViewEyeIconForPasswordConfirmation.isHidden = true
                passwordTFRegisterView.isSecureTextEntry = true
                passwordConfirmationTFRregisterView.isSecureTextEntry = true
            case .forgot:
                emailTextFieldForgetPassView.text = nil
            case .resetPass:
                newPasswordTFResetPassView.text = nil
            }
        } else {
            emailTFForLoginEmailView.text = nil
            passwordTFForLoginEmailView.text = nil
            emailTFRegisterView.text = nil
            passwordTFRegisterView.text = nil
            passwordConfirmationTFRregisterView.text = nil
            phoneNumberTFRegisterView.text = nil
            inviteCodeTFRegisterView.text = nil
            emailTextFieldForgetPassView.text = nil
            newPasswordTFResetPassView.text = nil
            passwordEyeIconForLoginEmailView.isHidden = true
            passwordTFForLoginEmailView.isSecureTextEntry = true
            registerViewEyeIconForPassword.isHidden = true
            registerViewEyeIconForPasswordConfirmation.isHidden = true
            passwordTFRegisterView.isSecureTextEntry = true
            passwordConfirmationTFRregisterView.isSecureTextEntry = true
        }
    }
    
    private func openMainScene() {
        if let delegate = delegate {
            if STAppManager.shared.isUserLoggedIn {
                delegate.loginSuccessful()
            } else {
                delegate.loginUnsuccessful()
            }
            if isModal {
                dismiss(animated: true, completion: nil)
            } else {
                navigationController?.popViewController(animated: true)
            }
        } else {
            //let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //appDelegate.openLoginScene()
            self.dismiss(animated: true)
        }
    }
}

// MARK: - Storyboard Extension
extension AuthVC: StoryboardBased {
    public static var storyboardName: String {
        return "MainEntry"
    }
}

// MARK: - Apple login Delegates
extension AuthVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let identityToken = appleIDCredential.identityToken
            let identityTokenStr = String(decoding: identityToken ?? Data(), as: UTF8.self)
            viewModel.signInWithApple(with: identityTokenStr)
            
            let authCodeString = String(decoding: appleIDCredential.authorizationCode ?? Data(), as: UTF8.self)
            STUserSession.current.appleAuthorizationCode = authCodeString
            
        case let passwordCredential as ASPasswordCredential:
            let _ = passwordCredential.user
            let _ = passwordCredential.password
            
        default:
            break
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if let err = error as? ASAuthorizationError {
            switch err.code {
            case .canceled:
                showAlert(message: "Apple sign in canceled", withTitle: "Authorization Failed", buttonTitle: "Ok", handler: nil)
            case .failed:
                showAlert(message: "Apple sign in canceled", withTitle: "Authorization Failed", buttonTitle: "Ok", handler: nil)
            case .notHandled, .unknown, .invalidResponse:
                showAlert(message: "Please try again!", withTitle: "Authorization Failed", buttonTitle: "Ok", handler: nil)
            default:
                STLog.info("Unknown Apple authentication error")
            }
        }
    }
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

