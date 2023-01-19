//
//  StoryboardExtension.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/4/22.
//

import UIKit

public protocol Validatable {
    func validate() -> Result<Void, AppError>
}

// MARK: - NibBased

/// Provide mixins for easy loading of uiview from nib file
public protocol NibBased {
    static var nibName: String { get }
    static func instantiate() -> Self
}

public extension NibBased where Self: UIView {
    /// Name of the nib file from which UIView will be instantiated
    /// Must override this property if nib name is different from UIView's name
    static var nibName: String {
        return "\(Self.self)"
    }
    
    /// This method instantiate a uiview from nib file
    /// - Returns: UIView
    static func instantiate() -> Self  {
        let bundle = Bundle(for: Self.self)
        let nib = bundle.loadNibNamed(nibName, owner: self, options: nil)
        guard let view = nib?.first as? Self else {
            fatalError("Can't load view \(Self.self) from nib \(nibName)")
        }
        return view
    }
}

// MARK: - StoryboardBased

/// Provide mixins for easy loading of UIViewController from UIStoryboard
public protocol StoryboardBased {
    static var storyboardName: String { get }
    static var storyboardIdentifier: String { get }
    static func instantiate() -> Self
}

public extension StoryboardBased where Self: UIViewController {
    
    /// Name of the storyboard from which view controller will be instantiated
    /// Must override this property if storyboard name is different from view controller's name
    static var storyboardName: String {
        return "\(Self.self)"
    }
    
    /// Storyboard identifier for the view controller
    /// Must override this property if storyboard identifier is different from view controller's name
    static var storyboardIdentifier: String {
        return "\(Self.self)"
    }
    
    /// This method instantiate a UIViewController from UIStoryboard
    /// - Returns: UIViewController
    static func instantiate() -> Self  {
        let storyboard = UIStoryboard(name: storyboardName , bundle: Bundle(for: Self.self))
        guard let viewController = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
            fatalError("Can't load view controller \(Self.self) from storyboard named \(storyboardName)")
        }
        return viewController
    }
}
