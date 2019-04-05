//
//  Recipe.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 29/12/2018.
//  Copyright © 2018 Alberto Mario Bellini. All rights reserved.
//

import UIKit
import CoreData

@objc(Recipe)
class Recipe: DrinkObject {
    //MARK: Attributes
    
    //MARK: Initializers
    convenience init(with steps: [RecipeStep]){
        self.init()
        self.steps = NSOrderedSet(array: steps)
    }
    
    convenience init(dict: [String: Any]) {
        var steps: [RecipeStep] = []
        for step in dict["steps"] as? [[String: Any]] ?? [] {
            steps.append(RecipeStep(dict: step))
        }
        self.init(with: steps)
        self.id = dict["id"] as? String ?? ""
        self.fingerprint = dict["fingerprint"] as? String ?? ""
    }

}
