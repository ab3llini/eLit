//
//  RecipeStep.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 29/12/2018.
//  Copyright © 2018 Alberto Mario Bellini. All rights reserved.
//

import UIKit
import CoreData

class RecipeStep: CoreDataObject {
    
    //MARK: Initializers
    convenience init(description: String, drinkComponents: [DrinkComponent]){
        self.init()
        self.stepDescription = description
        self.witComponents = NSOrderedSet(array: drinkComponents)
    }
    
    convenience init(drinkComponents: [DrinkComponent]) {
        self.init(description: "", drinkComponents: drinkComponents)
    }
    
    
    //MARK: getter & setter
    func setDescription(description:String) {
        self.stepDescription = description
    }
}
