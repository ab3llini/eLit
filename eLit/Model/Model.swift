//
//  Model.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 04/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit

class Model: NSObject {
    //MARK: attributes
    private static let instance = Model()
    private var drinks: [Drink]
    
    //MARK: initializers
    private override init() {
        let em = EntityManager.getInstance()
        drinks = em.fetchAll(type: Drink.self) ?? []
    }
    
    //MARK: Accessors
    class func getInstance() -> Model {
        return instance
    }
    
    //MARK: Public Methods
    public func getDrinks() -> [Drink] {
        return self.drinks
    }
    
    public func addDrink(_ drink: Drink) {
        self.drinks.append(drink)
    }
    
    public func savePersistentModel() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }

}
