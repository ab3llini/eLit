//
//  MainTabBarController.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 11/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, DarkModeBehaviour {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setDarkMode(enabled: Preferences.shared.getSwitch(for: .darkMode))
        
        DarkModeManager.shared.register(component: self)

        
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        //TODO: Fix this mess
        /* Uncomment this if you wanto to not have the searh that keeps the state
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
 */
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setDarkMode(enabled: Bool) {
        if enabled {
            self.tabBar.barTintColor = UIColor.black
        } else {
            self.tabBar.barTintColor = UIColor.white
        }
    }
    


}
