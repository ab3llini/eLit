//
//  MainTabBarController.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 11/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Removing the text for the navigation controller items
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        barButtonItemAppearance.setTitleTextAttributes(attributes, for: .normal)
        barButtonItemAppearance.setTitleTextAttributes(attributes, for: .highlighted)

        // Present loading VC if we need to download the data from the server
        if (Model.shared.isEmpty()) {
            
            self.performSegue(withIdentifier: Navigation.toUpdateVC.rawValue, sender: self)
        }
        
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let navVC = self.selectedViewController as? LargeVbrantNavigatonController else {
            return
        }
        for i in navVC.viewControllers {
            if let searchVC = i as? SearchTableViewController {
                searchVC.currentDrinks = []
                searchVC.currentIngredients = []
                searchVC.reloadData()
                while true {
                    if let _ = navVC.topViewController as? SearchTableViewController {
                        break
                    } else {
                        navVC.popViewController(animated: false)
                    }
                }
            } else {
                
            }
        }
        guard let searchVC = navVC.topViewController as? SearchTableViewController else {
            return
        }
        searchVC.currentDrinks = []
        searchVC.currentIngredients = []
        searchVC.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
