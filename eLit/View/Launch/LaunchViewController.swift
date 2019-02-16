//
//  LaunchViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 12/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import GoogleSignIn

class LaunchViewController: UIViewController {
    
    @IBOutlet var launchLabel : ChangingLabel!
    @IBOutlet var launchSpinner : UIActivityIndicatorView!
    
    var strings = ["Adding sugar...", "Mixing things...", "Pouring vodka...", "Adding juice..."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        // Setup chain
        self.launchLabel.startChanging(every: 1, with: self.strings)
        self.retrieveData()
        
    }
    
    private func prepareData(realoadImages : Bool = false) {
        
        DispatchQueue.global().async {
            print("Preparing data...")
            
            //self.launchLabel.text = "Adding sugar..."
            Model.shared.getDrinks().forEach { (drink) in
                drink.setImage()
            }
            
            Model.shared.getCategories().forEach { (category) in
                category.setImage()
            }
            
            Model.shared.getIngredients().forEach { (ingredient) in
                ingredient.setImage()
            }
            
            DispatchQueue.main.sync {
                
                self.finalizeData()

            }
            
        }
        
    }
    
    private func finalizeData() {
        print("finalizing")
        
        // Compute core colors
        _ = Renderer.shared.getDrinkCoreColors()
        
        // Save new images data to db
        Model.shared.savePersistentModel()
        
        self.launchLabel.stopChanging()
        
        // Move to main vc
        self.performSegue(withIdentifier: Navigation.toMainVC.rawValue, sender: self)
        
    }
    
    private func retrieveData() {
    
        if Model.shared.isEmpty() {
            
            // Download drinks
            let init_drinks: (_: [String: Any]) -> Void = { response in
                
                if response["status"] as? String ?? "" == "ok" {
                    
                    let drinks = response["data"] as? [[String: Any]] ?? []
                    var drinkList: [Drink] = []
                    
                    
                    for drink in drinks {
                        let d = Drink(dict: drink)
                        drinkList.append(d)
                    }
                    
                    for drink in drinkList {
                        Model.shared.addDrink(drink)
                    }
                    
                    Model.shared.categories = EntityManager.shared.fetchAll(type: DrinkCategory.self) ?? []
                    
                    Model.shared.ingredients = EntityManager.shared.fetchAll(type: Ingredient.self) ?? []
                    
                    // Proceed
                    self.prepareData()
                    
                }
                else {
                    
                    self.displayError(error: "Something went wrong..")

                }
                
            }
            
            DataBaseManager.shared.fetchAllData(completion: init_drinks)
            
        }
        else {
            
            //self.launchLabel.text = "Adding juice..."
            
            let handler : (_: [String: Any]) -> Void = { response in
                
                if response["status"] as? String ?? "" == "ok" {
                    
                    DataBaseManager.shared.defaultUdateDbHandler(response)
                    
                    // Proceed
                    self.prepareData()
            
                }
                else {
                    
                    self.displayError(error: "Something went wrong..")
                    
                }
                
            }
            
            DataBaseManager.shared.updateDB(completion: handler)
            
        }
    
    }

    private func displayError(error : String) {
        self.launchLabel.stopChanging()
        self.launchLabel.text = error
        self.launchSpinner.isHidden = true
        
    }
    
}
