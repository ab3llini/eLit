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
class Ingredient: DrinkObjectWithImage {
    
    //MARK: Initializers
    convenience init(grade: Double, name: String) {
        self.init()
        self.grade = grade
        self.name = name
    }
    
    convenience init(name: String) {
        self.init(grade: 0, name: name)
    }
    
    convenience init(dict: [String: Any]) {
        self.init()
        self.id = dict["id"] as? String ?? ""
        self.fingerprint = dict["fingerprint"] as? String ?? ""
        self.grade = dict["grade"] as? Double ?? 0.0
        self.name = dict["name"] as? String
        self.ingredientDescription = dict["ingredient_description"] as? String
        self.imageURLString = dict["image"] as? String ?? ""
    }
    
    override func update(with data: [String : Any], savePersistent: Bool) {
        self.grade = data["grade"] as? Double ?? 0.0
        self.name = data["name"] as? String
        self.ingredientDescription = data["ingredient_description"] as? String
        self.imageURLString = data["image"] as? String ?? ""
        self.image = nil
        self.imageData = nil
        super.update(with: data, savePersistent: savePersistent)
    }

}
