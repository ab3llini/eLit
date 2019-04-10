//
//  AccountTableViewCell.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 18/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import GoogleSignIn

class AccountTableViewCell: UITableViewCell, DarkModeBehaviour {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signInContainer: UIView!
    
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.loginIndicator.hidesWhenStopped = true
        self.selectionStyle = .none
        self.setDarkMode(enabled: Preferences.shared.getSwitch(for: .darkMode))
        DarkModeManager.shared.register(component: self)
            
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let gid = GIDSignIn.sharedInstance() else {
            self.profileImageView.roundImage(with: 0, ofColor: .darkGray)
            return
        }
        if gid.hasAuthInKeychain() {
            self.profileImageView.roundImage(with: 1, ofColor: .darkGray)
        }
        else {
            self.profileImageView.roundImage(with: 0, ofColor: .darkGray)

        }

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
