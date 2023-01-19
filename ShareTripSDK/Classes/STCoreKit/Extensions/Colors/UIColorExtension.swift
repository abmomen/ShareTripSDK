//
//  UIColorExtension.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/20/22.
//

import UIKit

public extension UIColor {
   
    convenience init(redInt: Int, greenInt: Int, blueInt: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(redInt) / 255.0,
            green: CGFloat(greenInt) / 255.0,
            blue: CGFloat(blueInt) / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            redInt: (hex >> 16) & 0xFF,
            greenInt: (hex >> 8) & 0xFF,
            blueInt: hex & 0xFF,
            alpha: alpha
        )
    }
    
    // MARK:- App Template
    // MARK: App Primary Colors
    static var appPrimary: UIColor {
        //clearBlue
        //return UIColor(hex: 0x1882ff)
        return UIColor.clearBlue
    }
    
    static var appPrimaryLight: UIColor {
        //skyBlue
        //return UIColor(hex: 0x5bb4ff)
        return UIColor.skyBlue
    }
    
    static var appPrimaryDark: UIColor {
        //blueBlue
        //return UIColor(hex: 0x245dd8)
        // #colorLiteral(red: 0.03921568627, green: 0.4784313725, blue: 0.9921568627, alpha: 1)
        return UIColor.blueBlue
    }
    
    @nonobjc class var clearBlue: UIColor {
        return UIColor(red: 24.0 / 255.0, green: 130.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    @nonobjc class var skyBlue: UIColor {
        return UIColor(red: 91.0 / 255.0, green: 180.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    @nonobjc class var clearBlueTwo: UIColor {
        return UIColor(red: 42.0 / 255.0, green: 140.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    @nonobjc class var blueBlue: UIColor {
        return UIColor(red: 36.0 / 255.0, green: 93.0 / 255.0, blue: 216.0 / 255.0, alpha: 1.0)
    }
    
    
    
    static var appSecondary: UIColor {
        //orangeyRed
        return UIColor(hex: 0xff3326)
    }
    
    static var appSecondaryLight: UIColor {
        //peachyPink
        return UIColor(hex: 0xf79795)
    }
    
    static var appSecondaryDark: UIColor {
        //lipstick
        return UIColor(hex: 0xde1921)
    }
    
    static var templateGray: UIColor {
        //blueGray
        return UIColor(hex: 0x8e8e93)
    }
    
    /*
     static var templateDarkGray: UIColor {
     return UIColor(red:0.49, green:0.49, blue:0.49, alpha:1.0)
     }*/
    
    //MARK: Others
    static var silver: UIColor {
        return UIColor(hex: 0xd8d8d8)
    }
    
    static var yellowOrange: UIColor {
        return UIColor(hex: 0xfcb900)
    }
    
    static var midYellowOrange: UIColor {
        return UIColor(hex: 0xf9a825)
    }
    
    static var midOrrange: UIColor {
        return UIColor(hex: 0xf57f17)
    }
    
    static var dealsRed: UIColor {
        return UIColor(hex: 0xFF214D)
    }
    
    static var starYellow: UIColor {
        return UIColor(hex: 0xffd321)
    }
    
    static var platinum: UIColor {
        return UIColor(hex: 0xf5f4f2)
    }
    
    static var iceBlue: UIColor {
        return UIColor(hex: 0xe3f2ff)
    }
    
    @nonobjc class var offWhite: UIColor {
        return UIColor(white: 245 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var offWhiteLight: UIColor {
        return UIColor(white: 250.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var paleGray: UIColor {
        return UIColor(red: 239.0 / 255.0, green: 239.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var paleGrayTwo: UIColor {
        return UIColor(red: 242.0 / 255.0, green: 243.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var paleGrayThree: UIColor {
        return UIColor(redInt: 250, greenInt: 250, blueInt: 250, alpha: 1.0)
    }
    
    @nonobjc class var brownishGray: UIColor {
        return UIColor(white: 112.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var greyishBrown: UIColor {
        return UIColor(white: 76.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var charcoalGray: UIColor {
        return UIColor(red: 65.0 / 255.0, green: 64.0 / 255.0, blue: 66.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var paleLilac: UIColor {
        return UIColor(red: 229.0 / 255.0, green: 229.0 / 255.0, blue: 234.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var whitishGray: UIColor {
        return UIColor(red: 222.0 / 255.0, green: 222.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var lightBlueGray: UIColor {
        return UIColor(red: 209.0 / 255.0, green: 209.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var lightBlueGrayTwo: UIColor {
        return UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var blueGray: UIColor {
        return UIColor(red: 142.0 / 255.0, green: 142.0 / 255.0, blue: 147.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var tintGray: UIColor {
        return UIColor(white: 102.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var orangeyRed: UIColor {
        return UIColor(red: 1.0, green: 59.0 / 255.0, blue: 48.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var tangerine: UIColor {
        return UIColor(red: 1.0, green: 149.0 / 255.0, blue: 0.0, alpha: 1.0)
    }
    
    @nonobjc class var marigold: UIColor {
        return UIColor(red: 1.0, green: 204.0 / 255.0, blue: 0.0, alpha: 1.0)
    }
    
    @nonobjc class var marigoldTwo: UIColor {
        return UIColor(red: 1.0, green: 195.0 / 255.0, blue: 0.0, alpha: 1.0)
    }
    
    
    @nonobjc class var weirdGreen: UIColor {
        return UIColor(red: 76.0 / 255.0, green: 217.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var midGreen: UIColor {
        return UIColor(red: 67.0 / 255.0, green: 160.0 / 255.0, blue: 70.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var midGreenTwo: UIColor {
        return UIColor(red: 76.0 / 255.0, green: 175.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var robinSEgg: UIColor {
        return UIColor(red: 90.0 / 255.0, green: 200.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var deepSkyBlue: UIColor {
        return UIColor(red: 0.0, green: 122.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    @nonobjc class var warmBlue: UIColor {
        return UIColor(red: 88.0 / 255.0, green: 86.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var reddish: UIColor {
        return UIColor(red: 211.0 / 255.0, green: 47.0 / 255.0, blue: 47.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var reddishPink: UIColor {
        return UIColor(red: 1.0, green: 45.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var veryLightPink: UIColor {
        return UIColor(white: 239.0 / 255.0, alpha: 1.0)
    }
}
