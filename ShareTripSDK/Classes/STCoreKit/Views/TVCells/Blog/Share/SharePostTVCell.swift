//
//  SharePostTVTVCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 12/10/2020.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import UIKit

public class SharePostTVCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak private var sharePostLabel: UILabel!
    
    private var showHighlightAnimation = true
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8.0
        containerView.clipsToBounds = true
        selectionStyle = .none
    }
    
    //MARK: - Cell LifeCycle
    public override func setSelected(_ selected: Bool, animated: Bool) {
        setAsSelectedOrHighlighted(selected, animated: animated)
        super.setSelected(selected, animated: animated)
    }
    
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        setAsSelectedOrHighlighted(highlighted, animated: animated)
        super.setHighlighted(highlighted, animated: animated)
    }
    
    //MARK: - Utils
    public func configureCell(with buttonTitle: String = "SHARE POST"){
        sharePostLabel.text = buttonTitle
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
}
