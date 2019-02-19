//
//  DrinkTableViewTableViewCell.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 06/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit
import UIImageColors

class DrinkTableViewCell: UITableViewCell {
    
    
    // Outlets
    @IBOutlet public var drinkImageView : UIImageView!
    @IBOutlet public var backgroundImage : UIImageView!
    @IBOutlet weak var containerView: ContainerView!
    @IBOutlet weak var alcholicRibbonView: RibbonView!
    @IBOutlet weak var baseRIbbonView: RibbonView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    
    let animationDuration = 0.5

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Disable ugly selection effect
        self.selectionStyle = .none;
        
        self.containerView.layer.borderWidth = 1
        
        self.setDrinkBackgroundColor(color: .gray)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setDrinkImage(image : UIImage?) {
        
        self.drinkImageView.image = image
        

    }
    
    private func setDrinkBackgroundColor(color : UIColor) {
        
        self.backgroundImage.backgroundColor = color.withAlphaComponent(0.1)
        self.containerView.layer.borderColor = color.withAlphaComponent(0.2).cgColor
    
        
    }
    
    private func setAlcholicRibbon(degree: String, color : UIColor) {
        self.alcholicRibbonView.label.text = degree + "%"
        self.alcholicRibbonView.label.textColor = UIColor.black
        self.alcholicRibbonView.backgroundColor = color.withAlphaComponent(0.2)

    }
    
    private func setBaseRibbon(base: String, color : UIColor) {
        
        self.baseRIbbonView.label.text = base
        self.baseRIbbonView.backgroundColor = color
        self.baseRIbbonView.label.textColor = UIColor.black


    }
    
    public func setDrink(drink : Drink) {
        
        drink.setImageAndColor { (image, color) in
            UIView.animate(withDuration: self.animationDuration) {
                self.setBaseRibbon(base: (drink.ofCategory?.name)!, color: UIColor.white.withAlphaComponent(0.3))
                self.drinkNameLabel.text = drink.name
                self.setDrinkImage(image: image)
                self.setDrinkBackgroundColor(color: color)
                self.setAlcholicRibbon(degree: String(drink.degree), color: color)
            }
        
        }
        
    }
    
    
}
