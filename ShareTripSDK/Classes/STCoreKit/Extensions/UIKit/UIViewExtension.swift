//
//  UIViewExtension.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/4/22.
//

import UIKit

public extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat, frame: CGRect? = nil) {
        let viewFrame = frame ?? self.bounds
        let path = UIBezierPath(roundedRect: viewFrame, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.frame = viewFrame
        self.layer.mask = mask
    }
    
    func roundBottomCorners(radius: CGFloat, frame: CGRect? = nil) {
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = radius
            self.clipsToBounds = true
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            roundCorners([.bottomLeft, .bottomRight], radius: radius, frame: frame)
        }
    }
    
    func roundRightCorners(radius: CGFloat, frame: CGRect? = nil) {
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = radius
            self.clipsToBounds = true
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        } else {
            roundCorners([.topRight, .bottomRight], radius: radius, frame: frame)
        }
    }
    
    
    func roundTopCorners(radius: CGFloat, frame: CGRect? = nil) {
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = radius
            self.clipsToBounds = true
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            roundCorners([.topLeft, .topRight], radius: radius, frame: frame)
        }
    }
    
    func roundTopLeftAndBottomRightCorners(radius: CGFloat, frame: CGRect? = nil) {
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        } else {
            roundCorners([.topLeft, .bottomRight], radius: radius, frame: frame)
        }
        self.clipsToBounds = true
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
}

public extension UIView {
    
    /**
     Set a shadow on a UIView.
     - parameters:
     - color: Shadow color, defaults to black
     - opacity: Shadow opacity, defaults to 1.0
     - offset: Shadow offset, defaults to zero
     - radius: Shadow radius, defaults to 0
     - viewCornerRadius: If the UIView has a corner radius this must be set to match
     */
    
    func setShadowWithColor(color: UIColor?, opacity: Float?, offset: CGSize?, radius: CGFloat, viewCornerRadius: CGFloat?) {
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: viewCornerRadius ?? 0.0).cgPath
        layer.shadowColor = color?.cgColor ?? UIColor.black.cgColor
        layer.shadowOpacity = opacity ?? 1.0
        layer.shadowOffset = offset ?? CGSize.zero
        layer.shadowRadius = radius
    }
    
    func setDropShadow(shadowOpacity: Float, shadowRadius: CGFloat, shadowOffset: CGSize, shadowColor: CGColor) {
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
        layer.shadowColor = shadowColor
    }
    
    /*
     func addShadow(cornerRadius: CGFloat, maskedCorners: CACornerMask, color: UIColor, offset: CGSize, opacity: Float, shadowRadius: CGFloat) {
     self.layer.cornerRadius = cornerRadius
     self.layer.maskedCorners = maskedCorners
     self.layer.shadowColor = color.cgColor
     self.layer.shadowOffset = offset
     self.layer.shadowOpacity = opacity
     self.layer.shadowRadius = shadowRadius
     }
     */
    
    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }
}

public extension UISearchBar {
    var searchField: UITextField? {
        if #available(iOS 13.0, *) {
            return searchTextField
        } else {
            return subviews.map { $0.subviews.first(where: { $0 is UITextInputTraits}) as? UITextField }
            .compactMap { $0 }
            .first
        }
    }
}

public extension CALayer {
    func addZeplinShadow( color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 3, blur: CGFloat = 6, spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

public extension UIView {
    func addDashedBorder(with color: UIColor, width: CGFloat, radius: CGFloat) {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: radius).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func addZeplinShadow(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 3, blur: CGFloat = 6, spread: CGFloat = 0) {
        clipsToBounds = false
        layer.addZeplinShadow(color: color, alpha: alpha, x: x, y: y, blur: blur, spread: spread)
    }
}

public extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

public extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }
    
    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}

