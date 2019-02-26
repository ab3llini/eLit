//
//  SettingsTableViewCell.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 25/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell, DarkModeBehaviour {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setDarkMode(enabled: Preferences.shared.getSwitch(for: .darkMode))
        DarkModeManager.shared.register(component: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDarkMode(enabled: Bool) {
        if enabled {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        } else {
            self.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        }
    }

}
