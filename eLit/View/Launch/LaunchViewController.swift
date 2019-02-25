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
        
        if (Preferences.shared.getSwitch(for: .updates)) {

            // Setup chain
            self.launchLabel.startChanging(every: 1, with: self.strings)
            self.retrieveData()
            
        }
        else {
            self.performSegue(withIdentifier: Navigation.toMainVC.rawValue, sender: self)
        }
        
    }
    
    private func finalizeData() {
        
        // Save new images data to db
        Model.shared.savePersistentModel()
        
        // Move to main vc
        self.performSegue(withIdentifier: Navigation.toMainVC.rawValue, sender: self)
        
        // Stop label
        self.launchLabel.stopChanging()

        
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
                    
                }
                else {
                    
                    self.displayError(error: "Unable to fetch data")

                }
                // Proceed
                self.finalizeData()
                
            }
            
            DataBaseManager.shared.fetchAllData(completion: init_drinks)
            
        }
        else {
            
            //self.launchLabel.text = "Adding juice..."
            
            let handler : (_: [String: Any]) -> Void = { response in
                
                if response["status"] as? String ?? "" == "ok" {
                    
                    DataBaseManager.shared.defaultUdateDbHandler(response)
            
                }
                else {
                    
                    self.displayError(error: "Unable to update data")
                    
                }
                
                // Proceed
                self.finalizeData()
            }
            
            DataBaseManager.shared.updateDB(completion: handler)
            
        }
    
        
        
    }

    private func displayError(error : String) {
        print(error)
        self.launchLabel.stopChanging()
        self.launchLabel.text = error
        self.launchSpinner.isHidden = true
        
    }
    
}
