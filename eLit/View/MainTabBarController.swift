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
        
        switch item.title {
        case "Play":
            ConnectionManager.shared.startAdvertising()
            ConnectionManager.shared.startBrowsing()
        default:
            ConnectionManager.shared.stopAdvertising()
            ConnectionManager.shared.stopBrowsing()
            return
        }
    }
    
    
    func setDarkMode(enabled: Bool) {
        if enabled {
            self.tabBar.barTintColor = UIColor.black
        } else {
            self.tabBar.barTintColor = UIColor.white
        }
    }
    


}
