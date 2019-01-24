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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    

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
            self.nameLabel.text = drink.name ?? ""
            
            // TODO: fix this
            self.imageView?.image = UIImage(named: drink.image ?? ("Drink" + (["1", "2", "3", "4"].randomElement() ?? "1")))
        case .ingredient:
            let ingredient = object as! Ingredient
            self.nameLabel.text = ingredient.name ?? ""
            self.imageView?.image = UIImage(named: ("Drink" + (["1", "2", "3", "4"].randomElement() ?? "1")))
        }
        
        self.classLabel.text = type.rawValue
    }
    
}
