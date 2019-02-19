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
}

class DrinkSearchTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var objectImageView: UIImageView!
    @IBOutlet weak var objectNameLabel: UILabel!
    @IBOutlet weak var objectClassLabel: UILabel!
    
    var current : DrinkObject!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
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
            drink.setImage { image in
                if (object == self.current) {
                    self.objectImageView.image = image
                }
            }
            
        case .ingredient:
            let ingredient = object as! Ingredient
            self.objectNameLabel.text = ingredient.name ?? ""
            ingredient.setImage(completion: { image in
                if (object == self.current) {
                    self.objectImageView.image = image
                }
            })
        }
        
        self.objectClassLabel.text = type.rawValue
    }
    
}
