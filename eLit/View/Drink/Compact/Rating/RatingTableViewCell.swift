//
//  RatingTableViewCell.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 05/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import Cosmos

class RatingTableViewCell: UITableViewCell, DarkModeBehaviour {
    
    var viewController : UIViewController?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    var hasRecognizer = false
    var preferredRatingStarColor : UIColor!
    
    @IBOutlet weak var writeReviewImageView: UIImageView!
    @IBOutlet weak var showReviewImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        writeReviewImageView.tintColor = UIColor(red: 236/255, green: 69/255, blue: 90/255, alpha: 1)
        
        self.preferredRatingStarColor = ratingStars.settings.filledColor
                
        DarkModeManager.shared.register(component: self)
        
    }

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingStars: CosmosView!
    
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        if !self.hasRecognizer {
            
            self.headerView.addGestureRecognizer(gestureRecognizer)
            self.hasRecognizer = true
        }
    }
    
    func notifyUserNotLoggedIn() {
        
        let alert = UIAlertController(title: "Register/Login", message: "Either register or login to add a review", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
        
        
        viewController?.present(alert, animated: true)
        
    }
    
    @IBAction func onWriteReviewTap(_ sender: UIButton) {
        
        if !Model.shared.userHasAuthenticated() {
            
            self.notifyUserNotLoggedIn()
            return
            
        }
        
        if let vc = viewController {
            
            vc.performSegue(withIdentifier: Navigation.toAddReviewVC.rawValue, sender: vc)
            
        }
        
    }
    
    func setDarkMode(enabled: Bool) {
        
        var settings = CosmosSettings()
        
        settings.starMargin = 0
        settings.fillMode = .precise

        
        if (enabled) {
            settings.emptyBorderColor = .white
            settings.filledColor = .white
            settings.filledBorderColor = .white
            settings.emptyColor = .clear
            
            showReviewImageView.tintColor = .white
        }
        else {
            settings.emptyBorderColor = self.preferredRatingStarColor
            settings.filledColor = self.preferredRatingStarColor
            settings.filledBorderColor = self.preferredRatingStarColor
            settings.emptyColor = .clear
            
            showReviewImageView.tintColor = self.preferredRatingStarColor
        }
        
        self.ratingStars.settings = settings
        
    }
}
