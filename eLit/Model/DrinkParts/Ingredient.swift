//
//  Ingredient.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 29/12/2018.
//  Copyright © 2018 Alberto Mario Bellini. All rights reserved.
//

import UIKit
import CoreData

@objc(Ingredient)
class Ingredient: DrinkObject {
    //MARK: Attributes
    public override var description: String {
        return "name: \(String(describing: self.name))\n" +
        "grade: \(self.grade)" +
        "description: \(self.description)"
    }
    
    //MARK: Initializers
    convenience init(grade: Int16, name: String) {
        self.init()
        self.grade = grade
        self.name = name
    }
    
    convenience init(name: String) {
        self.init(grade: 0, name: name)
    }
    
    convenience init(dict: [String: Any]) {
        self.init()
        self.grade = dict["grade"] as? Int16 ?? 0
        self.name = dict["name"] as? String
        self.ingredientDescription = dict["ingredient_description"] as? String
    }

}
