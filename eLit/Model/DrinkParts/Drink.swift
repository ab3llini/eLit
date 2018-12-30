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
    
    //MARK: Initializers
    convenience init(name: String, recipe: Recipe) {
        self.init()
        self.name = name
        self.drinkRecipe = recipe
    }
        
}