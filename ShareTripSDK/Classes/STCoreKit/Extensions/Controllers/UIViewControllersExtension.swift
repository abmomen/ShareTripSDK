//
//  UIViewControllersExtension.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/23/22.
//

import UIKit

public extension UIViewController {
    
    func delay(_ delay: Double, closure:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    func showAlert(
        message: String,
        withTitle title: String? = nil,
        buttonTitle: String = "OK",
        handler: ((UIAlertAction) -> Void)? = nil
    ) {
        let error = UIAlertController(title: title , message: message, preferredStyle: .alert)
        error.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: handler))
        present(error, animated: true, completion: nil)
    }
    
    func showError(error: NSError) {
        showAlert(message: error.localizedDescription, withTitle: "Error")
    }
    
    //returns true only if the viewcontroller is presented
    
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            if let parent = parent, !(parent is UINavigationController || parent is UITabBarController) {
                return false
            }
            return true
        } else if let navController = navigationController, navController.presentingViewController?.presentedViewController == navController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
    
    var topbarHeight: CGFloat {
        return statusBarHeight + navigationBarHeight
    }
    
    var statusBarHeight: CGFloat {
        let window =  UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        guard let height = window?.windowScene?.statusBarManager?.statusBarFrame.height else { return 0 }
        return height
    }
    
    var navigationBarHeight: CGFloat {
        return self.navigationController?.navigationBar.frame.height ?? 0.0
    }
}
