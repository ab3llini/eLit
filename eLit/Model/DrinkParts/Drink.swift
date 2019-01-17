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
class Drink: CoreDataObject {
        
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
    
    convenience init(name: String, image: String, degree: Int16) {
        self.init()
        self.name = name
        self.image = image
        self.degree = degree
        
    }
    
    convenience init(dict: [String: Any]) {
        self.init()
        self.name = dict["name"] as? String ?? ""
        self.image = dict["image"] as? String ?? ""
        self.degree = dict["degree"] as? Int16 ?? 0
        self.drinkRecipe = Recipe(dict: dict["recipe"] as? [String: Any] ?? [:])
        self.drinkDescription = dict["drink_description"] as? String ?? ""
    }
        
}
