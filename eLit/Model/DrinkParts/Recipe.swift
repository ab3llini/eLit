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
class Recipe: CoreDataObject {
    //MARK: Attributes
    public override var description: String {
        let steps = self.steps?.array as! [RecipeStep]
        return steps.map({$0.description}).reduce("\n") {recipe, step in "\(recipe)\n\(step)"}
    }
    
    //MARK: Initializers
    convenience init(steps: [RecipeStep]){
        self.init()
        self.steps = NSOrderedSet(array: steps)
    }

}
