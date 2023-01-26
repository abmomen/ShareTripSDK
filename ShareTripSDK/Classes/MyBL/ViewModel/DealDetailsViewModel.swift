//
//  DealDetailsViewModel.swift
//  ShareTrip
//
//  Created by ST-iOS on 5/9/22.
//  Copyright © 2022 ShareTrip. All rights reserved.
//

import Foundation

enum DealsDetailsCellType: CaseIterable {
    case image
    case description
    case action
}

class DealDetailsViewModel {
    let deal: NotifierDeal
    let title = "Details"
    let cells: [DealsDetailsCellType] = [.image, .description]
    
    init(deal: NotifierDeal) {
        self.deal = deal
    }
    
    var dealImageStr: String? {
        return deal.imageUrl
    }
}
