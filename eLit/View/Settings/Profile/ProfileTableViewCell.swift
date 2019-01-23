//
//  ProfileTableViewCell.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 22/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var profileLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
