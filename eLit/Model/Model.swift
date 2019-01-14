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
    public static let shared = Model()
    private var drinks: [Drink]
    
    //MARK: initializers
    private override init() {
        let em = EntityManager.getInstance()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        _ = appDelegate.persistentContainer.viewContext
        drinks = em.fetchAll(type: Drink.self) ?? []
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
