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
        DarkModeManager.shared.register(component: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DarkModeManager.shared.requestUpdateFor(self)
    }

    
    func setDarkMode(enabled: Bool) {
        if enabled {
            self.tabBar.barTintColor = UIColor.black
        } else {
            self.tabBar.barTintColor = UIColor.white
        }
    }
    


}
