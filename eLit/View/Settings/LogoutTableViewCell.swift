//
//  LogoutTableViewCell.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 10/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import GoogleSignIn

protocol LogoutDelegate {
    
    func didLogout()
    
}

class LogoutTableViewCell: UITableViewCell {

    var delegate : LogoutDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onLogoutAction(_ sender: Any) {
        
        if let callback = self.delegate {
            GIDSignIn.sharedInstance()?.signOut()
            callback.didLogout()
        }
        
    }
}
