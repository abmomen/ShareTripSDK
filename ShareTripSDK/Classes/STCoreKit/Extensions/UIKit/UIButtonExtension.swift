//
//  UIButtonExtension.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/4/22.
//

import UIKit

public extension UIButton {
    
    func setBorder(cornerRadius: CGFloat, borderWidth: CGFloat = 1.0) {
        //backgroundColor = .clear
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        layer.borderColor = tintColor.cgColor
        clipsToBounds = true
    }
    
    func setButtonImageTintColor(_ color: UIColor) {
        let buttonImage = imageView?.image?.withRenderingMode(.alwaysTemplate)
        setImage(buttonImage, for: .normal)
        tintColor = color
    }
    
    func setupButtonPerTheme(tintColor: UIColor, imageEdgeInsets: UIEdgeInsets?){
        setButtonImageTintColor(tintColor)
        
        if let edgeInsets = imageEdgeInsets {
            contentEdgeInsets = edgeInsets
            contentMode = .scaleAspectFit
        } else {
            contentMode = .center
        }
    }
}

public extension UIButton {
    
    func centerImageAndButton(_ gap: CGFloat, imageOnTop: Bool) {
        
        guard let imageView = self.currentImage,
              let titleLabel = self.titleLabel?.text else { return }
        
        let sign: CGFloat = imageOnTop ? 1 : -1
        self.titleEdgeInsets = UIEdgeInsets(top: (imageView.size.height + gap) * sign, left: -imageView.size.width, bottom: 0, right: 0);
        
        let titleSize = titleLabel.size(withAttributes:[NSAttributedString.Key.font: self.titleLabel!.font!])
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + gap) * sign, left: 0, bottom: 0, right: -titleSize.width)
    }
    
    func leftImageCenterText(image : UIImage, imagePadding: CGFloat, renderingMode: UIImage.RenderingMode){
        self.setImage(image.withRenderingMode(renderingMode), for: .normal)
        guard let imageViewWidth = self.imageView?.frame.width else{return}
        guard let titleLabelWidth = self.titleLabel?.intrinsicContentSize.width else{return}
        self.contentHorizontalAlignment = .left
        let imageLeft = imagePadding - imageViewWidth / 2
        let titleLeft = (bounds.width - titleLabelWidth) / 2 - imageViewWidth
        imageEdgeInsets = UIEdgeInsets(top: 0.0, left: imageLeft, bottom: 0.0, right: 0.0)
        titleEdgeInsets = UIEdgeInsets(top: 0.0, left: titleLeft , bottom: 0.0, right: 0.0)
    }
    
    func leftImage(image: UIImage, renderMode: UIImage.RenderingMode) {
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: image.size.width / 2)
        self.contentHorizontalAlignment = .left
        self.imageView?.contentMode = .scaleAspectFit
        
        /*
         let rightInset = (image.size.width / 2) + 10
         self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: rightInset)
         */
    }
    
    func rightImage(image: UIImage, renderMode: UIImage.RenderingMode){
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left:image.size.width / 2, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .right
        self.imageView?.contentMode = .scaleAspectFit
    }
    
}

