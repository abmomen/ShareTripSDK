//
//  UINavigationControllerExtension.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/5/22.
//

import UIKit

extension UINavigationController {
    public var previousViewController: UIViewController? {
        return viewControllers.count > 1 ? viewControllers[viewControllers.count - 2] : nil
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
    
    public func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
}
