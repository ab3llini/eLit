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
class DrinkComponent: DrinkObject {
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
    
    convenience init(dict: [String: Any]){
        self.init()
        self.id = dict["id"] as? String ?? ""
        self.fingerprint = dict["fingerprint"] as? String ?? ""
        self.qty = dict["qty"] as? Int16 ?? 0
        self.unit = dict["unit"] as? String
        let ingredientDict = dict["ingredient"] as? [String: Any] ?? [:]
        let ingredientID = ingredientDict["id"] as? String ?? ""
        if let ingredient = EntityManager.shared.fetchOne(of: Ingredient.self, with: ingredientID) {
            self.withIngredient = ingredient
        } else {
            self.withIngredient = Ingredient(dict: dict["ingredient"] as? [String: Any] ?? [:])
        }
    }

}
