//
//  Recipe.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 29/12/2018.
//  Copyright © 2018 Alberto Mario Bellini. All rights reserved.
//

import UIKit
import CoreData

class Recipe: CoreDataObject {
    
    //MARK: Initializers
    convenience init(steps: [RecipeStep]){
        self.init()
        self.steps = NSOrderedSet(array: steps)
    }

}