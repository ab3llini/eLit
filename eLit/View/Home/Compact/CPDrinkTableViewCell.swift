//
//  DrinkTableViewTableViewCell.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 06/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit
import UIImageColors
import Cosmos

class CPDrinkTableViewCell: UITableViewCell, DarkModeBehaviour {
    
    
    // Outlets
    @IBOutlet public var drinkImageView : UIImageView!
    @IBOutlet weak var drinkNameLabel: AdaptiveLabel!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var categoryLabel: AdaptiveLabel!
    @IBOutlet weak var degreeLabel: AdaptiveLabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var degreeRibbonView: RibbonView!
    
    let animationDuration = 0.2
    var drink : Drink!
    
    var defaultRatingSettings : CosmosSettings?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Disable ugly selection effect
        self.selectionStyle = .none;
        
        // Rotate the image view by 45 degrees
        self.backgroundImageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 10)
        
        // Fade out a bit the view - already done in setDarkMode
        // self.blurView.alpha = 0.5
        
        // Hide the rating until fully loaded
        self.ratingView.alpha = 0
        
        // Add blur effect
        _ = self.blurView.addBlurEffect(effect: .extraLight)
                
        // Register for dark mode updates
        DarkModeManager.shared.register(component: self)
                
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch (UIScreen.main.traitCollection.horizontalSizeClass) {
        case .regular:
            self.ratingView.settings.starSize = 25.0
        default:
            return
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    private func setDrinkImage() {
        
        self.drink.setImage(to: self.drinkImageView, transitioning: false)
        
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
        }
        else {
            self.blurView.alpha = 0.5
            if self.defaultRatingSettings != nil {
                self.ratingView.settings = self.defaultRatingSettings!
            }
        }
    }
    
    
    public func setDrink(drink : Drink) {
        
        self.drink = drink
        
        self.setDrinkImage()
        self.setBackgroundColor()
        self.setBackgroundImage()
        self.setRating()
    
        self.drinkNameLabel.text = drink.name
        self.categoryLabel.text = (drink.ofCategory?.name)!

        self.ratingView.isHidden = !Preferences.shared.getSwitch(for: .homeRating)
    }
    
    
}
