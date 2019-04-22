//
//  RGDrinkImageTableViewCell.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 29/03/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import Cosmos

class RGDrinkImageTableViewCell: UITableViewCell, DarkModeBehaviour {

    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var drinkVol: AdaptiveLabel!
    @IBOutlet weak var drinkTitle: AdaptiveLabel!
    @IBOutlet weak var drinkCategory: AdaptiveLabel!
    @IBOutlet weak var drinkDescription: AdaptiveLabel!
    @IBOutlet weak var drinkRatingStars: CosmosView!
    @IBOutlet weak var drinkRatingVal: AdaptiveLabel!
    @IBOutlet weak var writeReviewImageView: UIImageView!
    
    
    var viewController : UIViewController?
    var preferredRatingStarColor : UIColor!

    private var hasRecognizer = false

    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        if !self.hasRecognizer {
            
            self.drinkRatingStars.addGestureRecognizer(gestureRecognizer)
            self.hasRecognizer = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        writeReviewImageView.tintColor = UIColor(red: 236/255, green: 69/255, blue: 90/255, alpha: 1)
        self.preferredRatingStarColor = self.drinkRatingStars.settings.filledColor
        
        DarkModeManager.shared.register(component: self)
        
    }
    func setDarkMode(enabled: Bool) {
        
        var settings = CosmosSettings()
        
        settings.starMargin = 0
        settings.fillMode = .precise
        
        
        if (enabled) {
            self.drinkRatingStars.settings.emptyBorderColor = .white
            self.drinkRatingStars.settings.filledColor = .white
            self.drinkRatingStars.settings.filledBorderColor = .white
            self.drinkRatingStars.settings.emptyColor = .clear
        }
        else {
            self.drinkRatingStars.settings.emptyBorderColor = self.preferredRatingStarColor
            self.drinkRatingStars.settings.filledColor = self.preferredRatingStarColor
            self.drinkRatingStars.settings.filledBorderColor = self.preferredRatingStarColor
            self.drinkRatingStars.settings.emptyColor = .clear
                    }
        
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setDrink(_ drink : Drink) {
        
        drink.setImage(to: self.drinkImage)
        drink.getRating { (rating) in
            self.drinkRatingVal.text = String(format: "%.1f", rating)
            self.drinkRatingStars.rating = rating
        }
        
        self.drinkVol.text = String(format: "%.1f%% vol.", drink.degree)
        self.drinkTitle.text = drink.name
        self.drinkCategory.text = drink.ofCategory?.name
        self.drinkDescription.text = drink.drinkDescription
        
        
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
    
    func notifyUserNotLoggedIn() {
        
        let alert = UIAlertController(title: "Register/Login", message: "Either register or login to add a review", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
        
        
        viewController?.present(alert, animated: true)
        
    }
    
}
