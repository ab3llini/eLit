//
//  DrinkComponent.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 29/12/2018.
//  Copyright © 2018 Alberto Mario Bellini. All rights reserved.
//

import UIKit
import CoreData

@objc(DrinkComponent)
class DrinkComponent: CoreDataObject {
    //MARK: Attributes
    public override var description: String {
        return "\(self.qty) \(String(describing: ((self.unit) != nil) ? self.unit! : "")) " +
            self.withIngredient!.name!
    }
    
    //MARK: Initializers
    convenience init(ingredient: Ingredient, quantity: Int16, unit: Unit) {
        self.init()
        self.withIngredient = ingredient
        self.qty = quantity
        self.unit = unit.rawValue
    }

}
