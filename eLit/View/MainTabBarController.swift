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

        
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        //TODO: Fix this mess
        
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
