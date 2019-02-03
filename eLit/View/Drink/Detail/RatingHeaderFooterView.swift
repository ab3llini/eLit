//
//  RatingHeaderFooterView.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 31/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import Cosmos

class RatingHeaderFooterView: UITableViewHeaderFooterView {

    let hasRecognizer = false
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingStars: CosmosView!
    
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        if !self.hasRecognizer {
            
            super.addGestureRecognizer(gestureRecognizer)
            
        }
    }

}
