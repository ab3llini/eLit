//
//  LaunchViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 12/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    @IBOutlet var launchLabel : UILabel!
    @IBOutlet var launchSpinner : UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        if Model.shared.isEmpty() {
            
            self.launchLabel.text = "Pouring vodka..."
            
            //Loading data from remote server
            let dataCreation: (_: [String: Any]) -> Void = { response in
                
                if response["status"] as? String ?? "" == "ok" {
                    
                    let drinks = response["data"] as? [[String: Any]] ?? []
                    var drinkList: [Drink] = []
                    DispatchQueue.main.async {
                        for drink in drinks {
                            let d = Drink(dict: drink)
                            drinkList.append(d)
                        }
                        
                        for drink in drinkList {
                            Model.shared.addDrink(drink)
                        }
                        
                        Model.shared.savePersistentModel()
                        
                        // Move to main vc
                        self.performSegue(withIdentifier: Navigation.toMainVC.rawValue, sender: self)
                    
                    }
                    
                }
                else {
                    
                    DispatchQueue.main.async {
                    
                        self.displayError(error: "Something went wrong..")
                        
                    }
                    
                }
                
                
            }
            
            DataBaseManager.shared.fetchAllData(completion: dataCreation)
            
        }
        else {
            
            self.launchLabel.text = "Adding juice..."
            
            let handler : (_: [String: Any]) -> Void = { response in
                
                if response["status"] as? String ?? "" == "ok" {
                    
                    DataBaseManager.shared.defaultUdateDbHandler(response)
                    
                    DispatchQueue.main.async {

                        self.performSegue(withIdentifier: Navigation.toMainVC.rawValue, sender: self)
                        
                    }

                    
                }
                else {
                    
                    DispatchQueue.main.async {
                    
                        self.displayError(error: "Something went wrong..")
                        
                    }

                }
                
            }
            
            DataBaseManager.shared.updateDB(completion: handler)

            
        }
        
    }

    private func displayError(error : String) {
        
        self.launchLabel.text = error
        self.launchSpinner.isHidden = true
        
    }
    
}
