//
//  Ingredient.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 29/12/2018.
//  Copyright © 2018 Alberto Mario Bellini. All rights reserved.
//

import UIKit
import CoreData

class Ingredient: CoreDataObject {
    
    //MARK: Initializers
    convenience init(grade: Int16, name: String) {
        self.init()
        self.grade = grade
        self.name = name
    }
    
    convenience init(name: String) {
        self.init(grade: 0, name: name)
    }

}
