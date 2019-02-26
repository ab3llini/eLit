//
//  DrinkSearchTableViewCell.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 24/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

enum ObjectClass: String {
    case drink = "Drink"
    case ingredient = "Ingredient"
    case category = "Category"
}

class DrinkSearchTableViewCell: UITableViewCell, DarkModeBehaviour {


    @IBOutlet weak var objectImageView: UIImageView!
    @IBOutlet weak var objectNameLabel: AdaptiveLabel!
    @IBOutlet weak var objectClassLabel: AdaptiveLabel!
    @IBOutlet weak var bgView: UIView!
    
    var current : DrinkObject!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setDarkMode(enabled: Preferences.shared.getSwitch(for: .darkMode))
        
        DarkModeManager.shared.register(component: self)
        
    }
    
    
    func setDarkMode(enabled: Bool) {
        
        if (enabled) {
            
            self.bgView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            
        }
        else {
            
            self.bgView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDrink(of type: ObjectClass, with object: DrinkObject) {
        
        self.current = object
        
        switch type {
        case .drink:
            let drink = object as! Drink
            self.objectNameLabel.text = drink.name ?? ""

            drink.setImage(to: self.objectImageView) { () -> Bool in
                return object == self.current
            }
        
            
        case .ingredient:
            let ingredient = object as! Ingredient
            self.objectNameLabel.text = ingredient.name ?? ""
            ingredient.getImage(completion: { image in
                if (object == self.current) {
                    self.objectImageView.image = image
                }
            })
            
        case .category:
            let category = object as! DrinkCategory
            self.objectNameLabel.text = category.name ?? ""
            category.getImage(completion: { image in
                if (object == self.current) {
                    self.objectImageView.image = image
                }
            })
        }
        
        
        
        self.objectClassLabel.text = type.rawValue
    }
    
}
