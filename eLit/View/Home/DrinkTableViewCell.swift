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

class DrinkTableViewCell: UITableViewCell {
    
    
    // Outlets
    @IBOutlet public var drinkImageView : UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    let animationDuration = 0.5
    
    var drink : Drink!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Disable ugly selection effect
        self.selectionStyle = .none;
        
        // Display default background color?
        //self.setBackgroundColor(color: .gray)
        
        // Rotate the image view by 45 degrees
        self.backgroundImageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 10)
        
        // Add blur effect
        _ = self.blurView.addBlurEffect(effect: .extraLight)
        
        self.blurView.alpha = 0.5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        
        self.degreeLabel.text = String(self.drink.degree) + "%"
        //self.degreeRibbon.label.textColor = UIColor.black
        //self.drink.setColor(to: self.degreeRibbon, alpha: 0.2)

    }
    
    private func setCategoryRibbon() {
        
        self.categoryLabel.text = (drink.ofCategory?.name)!
        //self.categoryRibbon.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        //self.categoryRibbon.label.textColor = UIColor.darkGray


    }
    
    private func setRating() {
        
        self.drink.getRating { (rating) in
            self.ratingView.rating = rating
        }
    }
    
    private func setBackgroundImage() {
        
        self.drink.setImage(to: self.backgroundImageView)
        
    }
    
    public func setDrink(drink : Drink) {
        
        self.drink = drink
        
        self.setCategoryRibbon()
        self.setDegreeRibbon()
        
        self.setDrinkImage()
        self.setBackgroundColor()
        self.setBackgroundImage()
        
        self.drinkNameLabel.text = drink.name

        
    }
    
    
}
