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
    @IBOutlet weak var writeReviewImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        writeReviewImageView.tintColor = UIColor(red: 236, green: 69, blue: 90, alpha: 1)
        
    }

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingStars: CosmosView!
    
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        if !self.hasRecognizer {
            
            super.addGestureRecognizer(gestureRecognizer)
            
        }
    }
    
    @IBAction func onWriteReviewTap(_ sender: UIButton) {
        
    
        
    }
}
