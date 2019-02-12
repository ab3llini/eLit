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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDrink(of type: ObjectClass, with object: DrinkObject) {
        switch type {
        case .drink:
            let drink = object as! Drink
            self.objectNameLabel.text = drink.name ?? ""
            
            // TODO: fix this
            self.objectImageView.image = drink.image
            
        case .ingredient:
            let ingredient = object as! Ingredient
            self.objectNameLabel.text = ingredient.name ?? ""
            self.objectImageView.image = UIImage(named: ("Drink" + (["1", "2", "3", "4"].randomElement() ?? "1")))
        }
        
        self.objectClassLabel.text = type.rawValue
    }
    
}
