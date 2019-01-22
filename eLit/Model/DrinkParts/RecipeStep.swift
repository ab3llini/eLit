//
//  RecipeStep.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 29/12/2018.
//  Copyright © 2018 Alberto Mario Bellini. All rights reserved.
//

import UIKit
import CoreData

@objc(RecipeStep)
class RecipeStep: DrinkObject {
    //MARK: Attributes
    public override var description: String {
        let components = self.withComponents?.array as! [DrinkComponent]
        return  components.map({$0.description}).reduce("STEP:\n") {str, component in "\(str)\t\(component)"} +
            "\n" + ((self.stepDescription != nil) ? self.stepDescription! : "")
    }
    
    //MARK: Initializers
    convenience init(description: String, drinkComponents: [DrinkComponent]){
        self.init()
        self.stepDescription = description
        self.withComponents = NSOrderedSet(array: drinkComponents)
    }
    
    convenience init(drinkComponents: [DrinkComponent]) {
        self.init(description: "", drinkComponents: drinkComponents)
    }
    
    convenience init(dict: [String: Any]) {
        var components: [DrinkComponent] = []
        for c in dict["components"] as? [[String: Any]] ?? [] {
            components.append(DrinkComponent(dict: c))
        }
        self.init(drinkComponents: components)
        self.stepDescription = dict["step_description"] as? String ?? ""
    }
    
    
    //MARK: getter & setter
    func setDescription(description:String) {
        self.stepDescription = description
    }
}
