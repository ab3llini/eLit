//
//  DrinkTableViewTableViewCell.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 06/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit

 class DrinkTableViewTableViewCell: UITableViewCell {
    
    
    // Outlets
    @IBOutlet public var drinkImageView : UIImageView!
    @IBOutlet public var backgroundImage : UIImageView!
    @IBOutlet weak var containerView: ContainerView!
    @IBOutlet weak var alcholicRibbonView: RibbonView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
                
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setDrinkImage(image : UIImage) {
        
        self.drinkImageView.image = image
        self.backgroundImage.image = image
        self.backgroundImage.addBlurEffect()
    }
    
    private func setAlcholicRibbon(degree: String, color : UIColor) {
        
        self.alcholicRibbonView.setText(value: degree + "%")
        self.alcholicRibbonView.setColor(color: color)
        
    }
    
    public func setDrink(drink : Drink, withImage image: UIImage) {
        
        self.setDrinkImage(image: image)
        self.setAlcholicRibbon(degree: String(drink.degree), color: image.getCenterPixelColor())
        self.drinkNameLabel.text = drink.description
        
    }
    
    
}
