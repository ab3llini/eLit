//
//  RGDrinkCollectionViewCell.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 18/03/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import Cosmos

class RGDrinkCollectionViewCell: UICollectionViewCell, DarkModeBehaviour {

    // Outlets
    @IBOutlet public var drinkImageView : UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var degreeRibbonView: RibbonView!
    @IBOutlet weak var containerView: ContainerView!
    
    let animationDuration = 0.2
    var drink : Drink!
    
    var defaultRatingSettings : CosmosSettings?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Rotate the image view by 45 degrees
        self.backgroundImageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 10)
        
        // Fade out a bit the view - already done in setDarkMode
        // self.blurView.alpha = 0.5
        
        // Hide the rating until fully loaded
        self.ratingView.alpha = 0
        
        // Add blur effect
        _ = self.blurView.addBlurEffect(effect: .extraLight)
        
        // Set default state
        self.setDarkMode(enabled: Preferences.shared.getSwitch(for: .darkMode))
        
        // Register for dark mode updates
        DarkModeManager.shared.register(component: self)
    
        // Add a very light border to the cell
        containerView.layer.borderWidth = 1
        
    }
    
    
    private func setDrinkImage() {
        
        self.drink.setImage(to: self.drinkImageView)
        
    }
    
    private func setBackgroundColor(color : UIColor? = nil) {
        
        guard (color != nil) else {
            self.drink.setColor(to: self.backgroundImageView, alpha: 0.3)
            self.drink.setColor(to: self.blurView, alpha: 0.2)
            
            return
        }
        
        self.backgroundImageView.backgroundColor = color?.withAlphaComponent(0.1)
        
    }
    
    
    private func setDegreeRibbon() {
        
        self.degreeLabel.text = String(self.drink.degree)
        
    }
    
    private func setDescription() {
        
        self.descriptionLabel.text = drink.drinkDescription
        
    }
    
    func setRating() {
        
        self.ratingView.alpha = 0
        self.degreeRibbonView.alpha = 0
        
        self.drink.getRating { (rating) in
            
            self.ratingView.rating = rating
            self.drink.getColors(completion: { (colors) in
                
                var settings = CosmosSettings()
                
                settings.fillMode = .precise
                settings.emptyBorderColor = colors.primary
                settings.emptyColor = .clear
                settings.filledColor = colors.primary
                settings.filledBorderColor = colors.primary
                settings.starMargin = 0
                
                self.defaultRatingSettings = settings
                
                if (!Preferences.shared.getSwitch(for: .darkMode)) {
                    self.ratingView.settings = settings
                }
                self.degreeRibbonView.color = colors.primary
                self.degreeRibbonView.show()
                
                UIView.animate(withDuration: self.animationDuration, animations: {
                    self.ratingView.alpha = 1
                })
            })
            
        }
    }
    
    private func setBackgroundImage() {
        
        self.drink.setImage(to: self.backgroundImageView)
        
    }
    
    func setDarkMode(enabled: Bool) {
        if (enabled) {
            
            var settings = CosmosSettings()
            
            settings.fillMode = .precise
            settings.emptyBorderColor = .white
            settings.emptyColor = .clear
            settings.filledColor = .white
            settings.filledBorderColor = .white
            settings.starMargin = 0
            
            self.ratingView.settings = settings
            self.blurView.alpha = 0
            containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        }
        else {
            self.blurView.alpha = 0.5
            containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor

            
            
            if self.defaultRatingSettings != nil {
                
                self.ratingView.settings = self.defaultRatingSettings!
            }
            
        }
    }
    
    
    public func setDrink(drink : Drink) {
        
        self.drink = drink
        
        self.setDescription()
        self.setDegreeRibbon()
        
        self.setDrinkImage()
        self.setBackgroundColor()
        self.setBackgroundImage()
        self.setRating()
        
        self.drinkNameLabel.text = drink.name
        self.ratingView.isHidden = !Preferences.shared.getSwitch(for: .homeRating)
        
    }

}