//
//  AdaptiveLabel.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 25/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class AdaptiveLabel: UILabel, DarkModeLabelBehaviour {
    
    
    var preferredColor : UIColor!
    
    override func awakeFromNib() {
        
        self.preferredColor = self.textColor
        
        self.setDarkMode(enabled: Preferences.shared.getSwitch(for: .darkMode))
        
        DarkModeManager.shared.register(view: self)
        
    }

}
