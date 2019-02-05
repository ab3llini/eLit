//
//  RatingTableViewCell.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 05/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import Cosmos

class RatingTableViewCell: UITableViewCell {

    let hasRecognizer = false

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingStars: CosmosView!
    
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        if !self.hasRecognizer {
            
            super.addGestureRecognizer(gestureRecognizer)
            
        }
    }
    
}
