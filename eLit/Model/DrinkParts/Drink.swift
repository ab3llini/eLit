//
//  Drink.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 29/12/2018.
//  Copyright © 2018 Alberto Mario Bellini. All rights reserved.
//

import UIKit
import CoreData

@objc(Drink)
class Drink: DrinkObjectWithImage {
    
    //MARK: Attributes
    public override var description: String {
        return self.name! + "\n\(String(describing: self.drinkRecipe))"
    }
    
    //MARK: Initializers
    convenience init(name: String, recipe: Recipe) {
        self.init()
        self.name = name
        self.drinkRecipe = recipe
    }
    
    convenience init(name: String, image: String, degree: Int16, recipe: Recipe? = nil) {
        self.init()
        self.name = name
        self.degree = degree
        self.drinkRecipe = recipe
    }
    
    convenience init(dict: [String: Any]) {
        self.init()
        self.id = dict["id"] as? String ?? ""
        self.fingerprint = dict["fingerprint"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.imageURLString = dict["image"] as? String ?? ""
        self.degree = dict["degree"] as? Int16 ?? 0
        self.drinkRecipe = Recipe(dict: dict["recipe"] as? [String: Any] ?? [:])
        self.drinkDescription = dict["drink_description"] as? String ?? ""
        self.createdBy = dict["created_by"] as? String ?? ""
    }
    
    //MARK: Methods
    public func ingredients() -> [Ingredient] {
        guard let recipeSteps = self.drinkRecipe?.steps?.array as? [RecipeStep] else {
            return []
        }
        
       return recipeSteps.flatMap { step in
            return (step.withComponents?.array as? [DrinkComponent] ?? []).compactMap { component in
                return component.withIngredient
            }
        }
    }
        
}
