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
    public var user: User?
    public let entityManager = EntityManager.shared
    
    //MARK: initializers
    private override init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        _ = appDelegate.persistentContainer.viewContext
        self.drinks = self.entityManager.fetchAll(type: Drink.self) ?? []
        self.user = self.entityManager.fetchAll(type: User.self)?.first
        self.user?.setImage()
        
        var ingredients: [Ingredient] = []
        for _ in 0...4 {
            ingredients.append(Ingredient(name: Model.randomString(length: 20)))
        }
        
        for i in 0...19 {
            let component = DrinkComponent(ingredient: ingredients[i%5], quantity: 1, unit: .PART)
            let step = RecipeStep(description: "", drinkComponents: [component])
            let recipe = Recipe(with: [step])
            let drink = Drink(name: "Drink" + String(i%5 + 1) + Model.randomString(length: 10)  , image: "Drink" + String(i%5 + 1), degree: Int16(i*10), recipe: recipe)
            drinks.append(drink)
        }
    }
    
    class func randomString(length: Int) -> String {
        let letters = "abc defgh ijklmn opqrs tuvwxyz "
        return String((0...length-1).map{ _ in letters.randomElement()! })
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
