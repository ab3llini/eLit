//
//  AccountTableViewCell.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 18/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import GoogleSignIn

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
            
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
