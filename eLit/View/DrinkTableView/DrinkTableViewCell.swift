//
//  DrinkTableViewTableViewCell.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 06/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit

 class DrinkTableViewCell: UITableViewCell {
    
    
    // Outlets
    @IBOutlet public var drinkImageView : UIImageView!
    @IBOutlet public var backgroundImage : UIImageView!
    @IBOutlet weak var containerView: ContainerView!
    @IBOutlet weak var alcholicRibbonView: RibbonView!
    @IBOutlet weak var baseRIbbonView: RibbonView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.backgroundImage.addBlurEffect()
        
        //Disable ugly selection effect
        self.selectionStyle = .none;

                
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setDrinkImage(image : UIImage, bgcolor : UIColor) {
        
        self.drinkImageView.image = image
        self.backgroundImage.image = image
        self.backgroundImage.backgroundColor = bgcolor.withAlphaComponent(0.3)

    }
    
    private func setAlcholicRibbon(degree: String, color : UIColor) {
        
        self.alcholicRibbonView.textField.text = degree + "%"
        self.alcholicRibbonView.backgroundColor = color
        self.alcholicRibbonView.textField.textColor = UIColor.white
        
    }
    
    private func setBaseRibbon(base: String, color : UIColor) {
        
        self.baseRIbbonView.textField.text = base
        self.baseRIbbonView.backgroundColor = color
        self.baseRIbbonView.textField.textColor = UIColor.black

    }
    
    public func setDrink(drink : Drink, withImage image: UIImage, andColor color: UIColor) {
        
        self.setDrinkImage(image: image, bgcolor: color)
        self.setAlcholicRibbon(degree: String(drink.degree), color: color.withAlphaComponent(0.5))
        self.setBaseRibbon(base: "Vodka", color: UIColor.white.withAlphaComponent(0.3))
        self.drinkNameLabel.text = drink.description
        
    }
    
    
}
