//
//  RoundedCornerView.swift
//  TBBD
//
//  Created by Mac on 5/14/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

@IBDesignable
public class RoundedCornerView: UIView {
    
    var cornerRadiusValue : CGFloat = 0
    var corners : UIRectCorner = []
    
    @IBInspectable public var cornerRadius:CGFloat {
        get {
            return cornerRadiusValue
        }
        set {
            cornerRadiusValue = newValue
        }
    }
    
    @IBInspectable public var topLeft : Bool {
        get {
            return corners.contains(.topLeft)
        }
        set {
            if newValue {
                corners.insert(.topLeft)
                updateCorners()
            } else {
                if corners.contains(.topLeft) {
                    corners.remove(.topLeft)
                    updateCorners()
                }
            }
        }
    }
    
    @IBInspectable public var topRight : Bool {
        get {
            return corners.contains(.topRight)
        }
        set {
            if newValue {
                corners.insert(.topRight)
                updateCorners()
            } else {
                if corners.contains(.topRight) {
                    corners.remove(.topRight)
                    updateCorners()
                }
            }
            
        }
    }
    
    @IBInspectable public var bottomLeft : Bool {
        get {
            return corners.contains(.bottomLeft)
        }
        set {
            if newValue {
                corners.insert(.bottomLeft)
                updateCorners()
            } else {
                if corners.contains(.bottomLeft) {
                    corners.remove(.bottomLeft)
                    updateCorners()
                }
            }
            
        }
    }
    
    @IBInspectable public var bottomRight : Bool {
        get {
            return corners.contains(.bottomRight)
        }
        set {
            if newValue {
                corners.insert(.bottomRight)
                updateCorners()
            } else {
                if corners.contains(.bottomRight) {
                    corners.remove(.bottomRight)
                    updateCorners()
                }
            }
        }
    }
    
    func updateCorners() {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadiusValue, height: cornerRadiusValue))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}


