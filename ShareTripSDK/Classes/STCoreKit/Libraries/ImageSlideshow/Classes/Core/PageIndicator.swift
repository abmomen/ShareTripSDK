//
//  PageIndicator.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 27.05.18.
//

import UIKit

/// Cusotm Page Indicator can be used by implementing this protocol
public protocol PageIndicatorView: AnyObject {
    /// View of the page indicator
    var view: UIView { get }

    /// Current page of the page indicator
    var page: Int { get set }

    /// Total number of pages of the page indicator
    var numberOfPages: Int { get set}
}

extension UIPageControl: PageIndicatorView {
    public var view: UIView {
        return self
    }

    public var page: Int {
        get {
            return currentPage
        }
        set {
            currentPage = newValue
        }
    }

    open override func sizeToFit() {
        var frame = self.frame
        frame.size = size(forNumberOfPages: numberOfPages)
        frame.size.height = 30
        self.frame = frame
    }
}

/// Page indicator that shows page in numeric style, eg. "5/21"
public class LabelPageIndicator: UILabel, PageIndicatorView {
    public var view: UIView {
        return self
    }

    public var numberOfPages: Int = 0 {
        didSet {
            updateLabel()
        }
    }

    public var page: Int = 0 {
        didSet {
            updateLabel()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        self.textAlignment = .center
    }

    private func updateLabel() {
        text = "\(page+1)/\(numberOfPages)"
    }

    public override func sizeToFit() {
        let maximumString = String(repeating: "8", count: numberOfPages) as NSString
        self.frame.size = maximumString.size(withAttributes: [.font: font ?? UIFont.systemFont(ofSize: 17)])
    }
}

// MARK: - Created By Mehedi

public class CustomLabelPageIndicator: UILabel, PageIndicatorView {
    public var view: UIView {
        return self
    }
    
    public var numberOfPages: Int = 0 {
        didSet {
            updateLabel()
        }
    }
    
    public var page: Int = 0 {
        didSet {
            updateLabel()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        
        self.textAlignment = .center
        textColor = .white
        tintColor = .white
        font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }

    lazy var imageString: NSAttributedString = {
        // create our NSTextAttachment
        let image = UIImage(named: "image-album-mono")!.tint(with: .white)!
        let rect = CGRect(x: 0, y: ((self.font.capHeight) - image.size.height).rounded() / 2, width: image.size.width, height: image.size.height)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = rect
        
        // wrap the attachment in its own attributed string so we can append it
        let attributedString = NSAttributedString(attachment: imageAttachment)
        return attributedString
    }()
    
    private func updateLabel() {
        
        // add the NSTextAttachment wrapper to our full string, then add some more text.
        let fullString: NSMutableAttributedString = NSMutableAttributedString(attributedString: imageString)
        fullString.append(NSAttributedString(string: " \(page+1)/\(numberOfPages)"))
        
        attributedText = fullString
    }
    
    public override func sizeToFit() {
        //let maximumString = String(repeating: "8", count: numberOfPages + 4) as NSString
        //let size = maximumString.size(withAttributes: [.font: font])
        //let origin = CGPoint(x: 0, y: -24.0)
        
        self.frame = CGRect(x: 0, y: 0, width: 120, height: 50)
    }
}


/// Page indicator that shows page in numeric style, eg. "5/21"
/*
public class CustomPageIndicator: UIView, PageIndicatorView {
    //MARK:- PageIndicatorView
    public var view: UIView {
        return self
    }
    
    public var numberOfPages: Int = 0 {
        didSet {
            updateLabel()
        }
    }
    
    public var page: Int = 0 {
        didSet {
            updateLabel()
        }
    }
    
    //MARK:- CustomPageIndicator
    let albumImageView = UIImageView()
    let pageLabel = UILabel()
    private var shouldSetupConstraints = true
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        //self.textAlignment = .center
    }
    
    private func updateLabel() {
        //text = "\(page+1)/\(numberOfPages)"
    }
    
    /*
    public override func sizeToFit() {
        let maximumString = String(repeating: "8", count: numberOfPages) as NSString
        self.frame.size = maximumString.size(withAttributes: [.font: font])
    }
    */
    
    override func updateConstraints() {
        if shouldSetupConstraints {
            
            // AutoLayout constraints

            albumImageView.leadingAnchor.constraint(equalTo: firstItemView.leadingAnchor, constant: 16.0).isActive = true
            albumImageView.centerYAnchor.constraint(equalTo: firstItemView.centerYAnchor).isActive = true
            albumImageView.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
            albumImageView.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
            
            pageLabel.leadingAnchor.constraint(equalTo: firstItemImageView.trailingAnchor, constant: 8.0).isActive = true
            pageLabel.centerYAnchor.constraint(equalTo: firstItemView.centerYAnchor).isActive = true
            pageLabel.trailingAnchor.constraint(equalTo: firstItemView.trailingAnchor, constant: -8.0).isActive = true
            
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
}
*/
