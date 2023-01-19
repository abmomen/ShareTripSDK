//
//  PassportCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 11/26/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit
import Kingfisher

public protocol PassportVisaCellDelegate: AnyObject {
    func passportViewTapped(cellIndexPath: IndexPath)
    func visaViewTapped(cellIndexPath: IndexPath)
}

public class PassportVisaCell: UITableViewCell {

    private weak var delegate: PassportVisaCellDelegate?
    private var cellIndexPath: IndexPath!

    @IBOutlet weak var passportImageView: UIImageView!
    @IBOutlet weak var visaImageView: UIImageView!
    public var count = 0

    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }

    private func setupView() {

        passportImageView.layer.cornerRadius = 5.0
        passportImageView.clipsToBounds = true
        passportImageView.contentMode = .scaleAspectFill
        visaImageView.layer.cornerRadius = 5.0
        visaImageView.clipsToBounds = true
        visaImageView.contentMode = .scaleAspectFill

        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(passportImageViewTapped(_:)))
        passportImageView.addGestureRecognizer(tapGesture1)
        passportImageView.isUserInteractionEnabled = true

        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(visaImageViewTapped(_:)))
        visaImageView.addGestureRecognizer(tapGesture2)
        visaImageView.isUserInteractionEnabled = true
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func configure(passportUrl: String, visaUrl: String, cellIndexPath: IndexPath, delegate: PassportVisaCellDelegate) {

        self.cellIndexPath = cellIndexPath
        self.delegate = delegate

        if let passportURL = URL(string: passportUrl) {
            passportImageView.contentMode = .scaleAspectFill
            passportImageView.kf.setImage(with: passportURL, placeholder: UIImage(named: "image-mono"))
        } else {
            passportImageView.contentMode = .scaleAspectFit
            passportImageView.image = UIImage(named: "image-mono")
        }

        if let visaURL = URL(string: visaUrl) {
            visaImageView.contentMode = .scaleAspectFill
            visaImageView.kf.setImage(with: visaURL, placeholder: UIImage(named: "image-mono"))
        } else {
            visaImageView.contentMode = .scaleAspectFit
            visaImageView.image = UIImage(named: "image-mono")

        }
    }

    public func configCell(cellIndexPath: IndexPath, delegate: PassportVisaCellDelegate){

    }

    @objc func passportImageViewTapped(_ sender: UITapGestureRecognizer) {
        delegate?.passportViewTapped(cellIndexPath: cellIndexPath)
    }

    @objc func visaImageViewTapped(_ sender: UITapGestureRecognizer) {
        delegate?.visaViewTapped(cellIndexPath: cellIndexPath)
    }

}
