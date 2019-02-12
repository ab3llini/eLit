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

        // Do any additional setup after loading the view.
        launchLabel.isHidden = true
        launchSpinner.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        if Model.shared.isEmpty() {
            
            launchLabel.isHidden = false
            launchSpinner.isHidden = false
            
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
                    
                    self.launchLabel.text = "Something went wrong.."
                    self.launchSpinner.isHidden = true
                    
                }
                
                
            }
            
            DataBaseManager.shared.fetchAllData(completion: dataCreation)
            
        }
        else {
            
            self.performSegue(withIdentifier: Navigation.toMainVC.rawValue, sender: self)
            
        }
        
    }
    
    
    

}
