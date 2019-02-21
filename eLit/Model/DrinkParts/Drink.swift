//
//  Drink.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 29/12/2018.
//  Copyright © 2018 Alberto Mario Bellini. All rights reserved.
//

import UIKit
import CoreData

struct Component {
    var qty: Double
    var unit: String
    var name: String
    
    var ingredient: Ingredient?
    
    func setImage(completion: @escaping (_ image: UIImage?) -> Void) -> Void {
        self.ingredient?.getImage(completion: completion)
    }
}

@objc(Drink)
class Drink: DrinkObjectWithImage {
    
    internal var rating : Double = -1.0

    
    //MARK: Attributes
    public override var description: String {
        return self.name! + "\n\(String(describing: self.drinkRecipe))"
    }
    
    //MARK: Initializers
    convenience init(name: String, recipe: Recipe) {
        self.init()
        self.name = name
        self.drinkRecipe = recipe
    }
    
    convenience init(name: String, image: String, degree: Double, recipe: Recipe? = nil) {
        self.init()
        self.name = name
        self.degree = degree
        self.drinkRecipe = recipe
    }
    
    convenience init(dict: [String: Any]) {
        self.init()
        self.id = dict["id"] as? String ?? ""
        self.fingerprint = dict["fingerprint"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.imageURLString = dict["image"] as? String ?? ""
        self.degree = dict["degree"] as? Double ?? 0
        self.drinkRecipe = Recipe(dict: dict["recipe"] as? [String: Any] ?? [:])
        self.drinkDescription = dict["drink_description"] as? String ?? ""
        self.createdBy = dict["created_by"] as? String ?? ""
        
        let categoryDict = dict["category"] as? [String: Any] ?? [:]
        let categoryID = categoryDict["id"] as? String ?? ""
        if let category = EntityManager.shared.fetchOne(of: DrinkCategory.self, with: categoryID) {
            self.ofCategory = category
        } else {
            self.ofCategory = DrinkCategory(dict: dict["category"] as? [String: Any] ?? [:])
        }
    }
    
    //MARK: Methods
    public func ingredients() -> [Ingredient] {
        guard let recipeSteps = self.drinkRecipe?.steps?.array as? [RecipeStep] else {
            return []
        }
        
       return recipeSteps.flatMap { step in
            return (step.withComponents?.array as? [DrinkComponent] ?? []).compactMap { component in
                return component.withIngredient
            }
        }
    }
    
    public func components() -> [Component] {
        guard let recipeSteps = self.drinkRecipe?.steps?.array as? [RecipeStep] else {
            return []
        }
        
        var components: [Component] = []
        for step in recipeSteps {
            
            for component in (step.withComponents?.array as? [DrinkComponent] ?? []) {
                let old: Double = components.first(where: {$0.name == component.withIngredient?.name})?.qty ?? 0
                components.removeAll(where: {$0.name == component.withIngredient?.name})
                components.append(Component(qty: old + component.qty, unit: component.unit ?? "", name: component.withIngredient?.name ?? "", ingredient: component.withIngredient))
            }
        }
        return components
    }
    
    override func update(with data: [String : Any], savePersistent: Bool) {
        self.name = data["name"] as? String ?? ""
        self.imageURLString = data["image"] as? String ?? ""
        self.degree = data["degree"] as? Double ?? 0
        self.drinkRecipe = Recipe(dict: data["recipe"] as? [String: Any] ?? [:])
        self.drinkDescription = data["drink_description"] as? String ?? ""
        self.createdBy = data["created_by"] as? String ?? ""
        self.image = UIImage()
        self.imageData = nil
        super.update(with: data, savePersistent: savePersistent)
    }
    
    func getRating (forceReload : Bool = false, completion : @escaping (_ : Double) -> Void) {
        
        
        let requestRating = {
            
            //Sending request for drink rating
            DataBaseManager.shared.requestRating(for: self, completion: { data in
                if (data["status"] as! String) == "ok" {
                    let ratingData = data["data"] as! [String: Any]
                    let rating = Double(ratingData["rating"] as? String ?? "0.0") ?? 0.0
                    completion(rating)
                }
                else {
                    completion(0.0)
                }
            })
            
        }
        
        if forceReload {
            
            requestRating()
            
        }
        
        else{
            
            if self.degree == -1.0 {
                requestRating()
            }
            else {
                completion(self.rating)
            }
            
        }
        
    }
    

}
