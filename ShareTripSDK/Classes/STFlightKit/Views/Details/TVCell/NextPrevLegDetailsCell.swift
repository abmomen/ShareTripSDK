//
//  NextPrevLegDetailsCell.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 02/12/2019.
//  Copyright © 2019 TBBD IOS. All rights reserved.
//

import UIKit

protocol NextPrevLegDetailsCellDelegate: AnyObject {
    func nextButtonTapped(for legId: Int)
    func prevButtonTapped(for legId: Int)
}

class NextPrevLegDetailsCell: UITableViewCell {
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func prevButtonTapped(_ sender: Any) {
        delegate?.prevButtonTapped(for: legId)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        delegate?.nextButtonTapped(for: legId)
    }
    
    private var legId: Int = -1
    private var isFirstLeg: Bool = false
    private var isLastLeg: Bool = false
    private weak var delegate: NextPrevLegDetailsCellDelegate?
    
    func configure(legId: Int,
                   prevButtonTitle: String,
                   nextButtonTitle: String,
                   isFirstLeg: Bool,
                   isLastLeg: Bool,
                   delegate: NextPrevLegDetailsCellDelegate) {
        self.legId = legId
        self.isFirstLeg = isFirstLeg
        self.isLastLeg = isLastLeg
        self.delegate = delegate
        
        prevButton.setTitle(prevButtonTitle, for: .normal)
        nextButton.setTitle(nextButtonTitle, for: .normal)
        
        prevButton.isHidden = isFirstLeg
        nextButton.isHidden = isLastLeg
        
        prevButton.tintColor = .appPrimary
        nextButton.tintColor = .appPrimary
    }
}
