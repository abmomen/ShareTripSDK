//
//  NotificationCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 10/16/19.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit
import Kingfisher

class DealCardCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var dealsImageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet private weak var dealsTypeView: UIView!
    @IBOutlet private weak var dealsTypeimageView: UIImageView!
    @IBOutlet private weak var dealsTypeLable: UILabel!
    
    private var showHighlightAnimation = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        setAsSelectedOrHighlighted(selected, animated: animated)
        super.setSelected(selected, animated: animated)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        setAsSelectedOrHighlighted(highlighted, animated: animated)
        super.setHighlighted(highlighted, animated: animated)
    }
    
    private func setAsSelectedOrHighlighted(_ selectedOrHighlighted: Bool, animated: Bool) {
        guard showHighlightAnimation else { return }
        
        let action: () -> Void = { [weak self] in
            self?.containerView.backgroundColor = selectedOrHighlighted ? .paleGray: .white
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: action, completion: nil)
        } else {
            action()
        }
    }
    
    func configure(dealsAndUpdates: NotifierDeal) {
        containerView.layer.cornerRadius = 8.0
        dealsImageView.layer.cornerRadius = 8.0
        titleLabel.text = dealsAndUpdates.title
        messageLabel.text = dealsAndUpdates.description?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        dateLabel.text = (dealsAndUpdates.timeStamp ?? 0.0).getStringDate()
        let url = URL(string: dealsAndUpdates.imageUrl ?? "")
        let placeholder = UIImage(named: "deals-placeholder-color")
        dealsImageView.kf.setImage(with: url, placeholder: placeholder)
        
        dealsTypeView.layer.cornerRadius = 4.0
        dealsTypeView.isHidden = true
    }
}
