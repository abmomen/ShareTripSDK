//
//  VisaPassportUploadVC.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 17/10/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit
import Photos

public class FileUploadController {
    
    // MARK: - Dependency
    private var topViewController: UIViewController
    private var imagePicker: UIImagePickerController
    
    // MARK: - Initializers
    public init(topViewController: UIViewController, imagePicker: UIImagePickerController) {
        self.topViewController = topViewController
        self.imagePicker = imagePicker
    }
    
    // MARK: - Private Functions
    private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: sourceType)!
            strongSelf.imagePicker.sourceType = sourceType
            strongSelf.topViewController.present(strongSelf.imagePicker, animated: true, completion: nil)
        }
    }
    
    private func openFullScreenImageViewer(attachmentURL: String) {
        if let kingfisherSource = KingfisherSource(urlString: attachmentURL) {
            let fullscreen = FullScreenSlideshowViewController()
            fullscreen.inputs = [kingfisherSource]
            fullscreen.slideshow.activityIndicator = DefaultActivityIndicator()
            fullscreen.modalPresentationStyle = .fullScreen
            topViewController.present(fullscreen, animated: true, completion: nil)
        }
    }
    
    private func handleRestricted() {
        let alertController = UIAlertController(title: "Media Access Denied", message: "This device is restricted from accessing any media at this time", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        topViewController.present(alertController, animated: true, completion: nil)
    }
    
    private func handledenied() {
        let alertController = UIAlertController(title: "Media Access Denied", message: "Remedy Messenger does not have access to use your device's media. Please update your settings.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Go To Settings", style: .default){ (action) in
            DispatchQueue.main.async {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        topViewController.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Public Functions
    
    public func showOptionsActionActionSheet() {
        let imageAlertController = UIAlertController(title: "Select", message: nil, preferredStyle: .actionSheet)
        
        //avaiability of device
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            //code for using camera
            let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { [weak self] (action) in
                
                switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
                case .notDetermined:
                    //ask for request
                    AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [weak self] (granted) in
                        if (granted){
                            self?.openImagePicker(sourceType: .camera)
                        }
                    })
                case .restricted:
                    self?.handleRestricted()
                case .denied:
                    self?.handledenied()
                case .authorized:
                    self?.openImagePicker(sourceType: .camera)
                @unknown default:
                    STLog.warn("AVCaptureDevice.authorizationStatus: unknown default")
                }
            }
            
            imageAlertController.addAction(cameraAction)
        }
        
        //code for using library
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            
            let photoLibraryAction = UIAlertAction(title: "Choose From Photo Library", style: .default) { [weak self] (action) in
                switch PHPhotoLibrary.authorizationStatus() {
                case .notDetermined:
                    //ask for request
                    PHPhotoLibrary.requestAuthorization({(status) in
                        if (status == PHAuthorizationStatus.authorized){
                            self?.openImagePicker(sourceType: .photoLibrary)
                        }
                    })
                case .restricted:
                    self?.handleRestricted()
                case .denied:
                    self?.handledenied()
                case .authorized:
                    self?.openImagePicker(sourceType: .photoLibrary)
                default:
                    STLog.warn("PHPhotoLibrary.authorizationStatus: unknown default")
                }
            }
            
            imageAlertController.addAction(photoLibraryAction)
        }
        
        //cancel action
        let cancelEditAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        imageAlertController.addAction(cancelEditAction)
        if let popoverController = imageAlertController.popoverPresentationController {
            popoverController.sourceView = topViewController.view
            popoverController.sourceRect = CGRect(x: topViewController.view.bounds.midX, y: topViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        topViewController.present(imageAlertController, animated: true, completion: nil)
    }
    
    public func showAttachmentActionSheet(attachmentURL: String, title: String) {
        let alertController = UIAlertController(title: "Select", message: nil, preferredStyle: .actionSheet)
        
        let showAction = UIAlertAction(title: title, style: .default) { [weak self] (action) in
            self?.openFullScreenImageViewer(attachmentURL: attachmentURL)
        }
        alertController.addAction(showAction)
        
        let uploadAction = UIAlertAction(title: "Upload New Copy", style: .default) { [weak self] (action) in
            self?.showOptionsActionActionSheet()
        }
        alertController.addAction(uploadAction)
        
        //cancel action
        let cancelEditAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelEditAction)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = topViewController.view
            popoverController.sourceRect = CGRect(x: topViewController.view.bounds.midX, y: topViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        topViewController.present(alertController, animated: true, completion: nil)
    }
    
    public func previewAttachmentSheet(attachmentURL: String, title: String) {
        let alertController = UIAlertController(title: "Select", message: nil, preferredStyle: .actionSheet)
        
        let showAction = UIAlertAction(title: title, style: .default) { [weak self] (action) in
            self?.openFullScreenImageViewer(attachmentURL: attachmentURL)
        }
        alertController.addAction(showAction)
        
        //cancel action
        let cancelEditAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelEditAction)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = topViewController.view
            popoverController.sourceRect = CGRect(x: topViewController.view.bounds.midX, y: topViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        topViewController.present(alertController, animated: true, completion: nil)
    }
}
