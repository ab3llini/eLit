//
//  Model.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 04/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit
import GoogleSignIn

class Model: NSObject {
    //MARK: attributes
    public static let shared = Model()
    private var drinks: [Drink]
    public var categories: [DrinkCategory]
    public var ingredients: [Ingredient]
    public var user: User?
    public let entityManager = EntityManager.shared
    
    //MARK: initializers
    private override init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        _ = appDelegate.persistentContainer.viewContext
        self.drinks = self.entityManager.fetchAll(type: Drink.self) ?? []
        self.user = self.entityManager.fetchAll(type: User.self)?.first
        self.categories = self.entityManager.fetchAll(type: DrinkCategory.self) ?? []
        self.ingredients = self.entityManager.fetchAll(type: Ingredient.self) ?? []
        self.user?.setImage()
        
    }
    
    //MARK: Public Methods
    public func getDrinks() -> [Drink] {
        return self.drinks
    }
    
    public func getCategories() -> [DrinkCategory] {
        return self.categories
    }
    
    public func getIngredients() -> [Ingredient] {
        return self.ingredients
    }
    
    public func addDrink(_ drink: Drink) {
        self.drinks.append(drink)
    }
    
    public func savePersistentModel() {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.saveContext()
        }
    }
    
    public func reloadDrinks() {
        self.drinks = self.entityManager.fetchAll(type: Drink.self) ?? []
    }

    public func isEmpty() -> Bool {
        
        return (self.drinks.count == 0)
        
    }
    
    public func userHasAuthenticated() -> Bool {
    
        guard let gid = GIDSignIn.sharedInstance() else { return false }
        return gid.hasAuthInKeychain()
    
    }
    
}
