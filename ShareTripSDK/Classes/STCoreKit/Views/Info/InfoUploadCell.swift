//
//  InfoUploadCell.swift
//  TBBD
//
//  Created by Mac on 5/12/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

public class InfoUploadCell: UITableViewCell {
    
    @IBOutlet private weak var passportLabel: UILabel!
    @IBOutlet private weak var passportBtn: UIButton!
    @IBOutlet private weak var visaLabel: UILabel!
    @IBOutlet private weak var visaBtn: UIButton!
    @IBOutlet private weak var passportProgressView: UIProgressView!
    @IBOutlet private weak var visaProgressView: UIProgressView!
    
    var isPassportProgressHidden = true
    var isVisaProgressHidden = true
    
    //Private Properties
    public var didSelectUpload: (FileType) -> Void = { _ in }
    
    private var currentlyUploadingFileType: FileType?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupScene()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupScene() {
        passportBtn.clipsToBounds = true
        passportBtn.layer.cornerRadius = 8.0
        
        visaBtn.clipsToBounds = true
        visaBtn.layer.cornerRadius = 8.0
        
        passportProgressView.isHidden = isPassportProgressHidden
        visaProgressView.isHidden = isVisaProgressHidden
    }
    
    public func resetProgressBarView(fileType: FileType){
        switch fileType {
        case .passport:
            if isPassportProgressHidden {
                isPassportProgressHidden = false
                passportProgressView.isHidden = false
            }
            passportProgressView.setProgress(0.0, animated: false)
        case .visa:
            if isVisaProgressHidden {
                isVisaProgressHidden = false
                visaProgressView.isHidden = false
            }
            visaProgressView.setProgress(0.0, animated: false)
        }
    }
    
    public func updateProgressBarView(progress: Float, fileType: FileType){
        switch fileType {
        case .passport:
            if isPassportProgressHidden {
                isPassportProgressHidden = false
                passportProgressView.isHidden = false
            }
            passportProgressView.setProgress(progress, animated: true)
        case .visa:
            if isVisaProgressHidden {
                isVisaProgressHidden = false
                visaProgressView.isHidden = false
            }
            visaProgressView.setProgress(progress, animated: true)
        }
    }
    
    //MARK:- IBActions
    @IBAction private func passportButtonTapped(_ sender: UIButton) {
        didSelectUpload(.passport)
    }
    
    @IBAction private func visaButtonTapped(_ sender: UIButton) {
        didSelectUpload(.visa)
    }
    
    //MARK:- Deinit
    deinit {
        STLog.info("\(String(describing: self)) deinit")
    }
}

//MARK:- ConfigurableTableViewCellDataContainer
extension InfoUploadCell: ConfigurableTableViewCellDataContainer {
    public typealias AccecptableViewModelType = InfoUploadCellData
}

//MARK:- ConfigurableTableViewCell
extension InfoUploadCell: ConfigurableTableViewCell {
    public func configure(viewModel: ConfigurableTableViewCellData) {
        guard let viewModel = viewModel as? AccecptableViewModelType else {
            STLog.error("Can't convert ConfigurableTableViewCellData as \(String(describing: AccecptableViewModelType.self))")
            return
        }
        
        selectionStyle = .none
        
        if viewModel.hasPassportCopy {
            passportBtn.setTitle("Uploaded", for: .normal)
            passportBtn.backgroundColor = UIColor.appPrimary
            passportBtn.centerImageAndButton(6.0, imageOnTop: true)
        } else {
            passportBtn.setTitle("Upload", for: .normal)
            passportBtn.backgroundColor = UIColor.paleGray
            passportBtn.centerImageAndButton(6.0, imageOnTop: true)
        }
        
        if viewModel.hasVisaCopy {
            visaBtn.setTitle("Uploaded", for: .normal)
            visaBtn.backgroundColor = UIColor.appPrimary
            visaBtn.centerImageAndButton(6.0, imageOnTop: true)
        } else {
            visaBtn.setTitle("Upload", for: .normal)
            visaBtn.backgroundColor = UIColor.paleGray
            visaBtn.centerImageAndButton(6.0, imageOnTop: true)
        }
        
        if viewModel.passportHidden {
            passportLabel.isHidden = true
            passportBtn.isHidden = true
        } else {
            passportLabel.isHidden = false
            passportBtn.isHidden = false
        }
        
        if viewModel.visaHidden {
            visaLabel.isHidden = true
            visaBtn.isHidden = true
        } else {
            visaLabel.isHidden = false
            visaBtn.isHidden = false
        }
    }
}
