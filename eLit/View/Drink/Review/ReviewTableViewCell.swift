//
//  ReviewTableViewCell.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 29/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import Cosmos

class ReviewTableViewCell: UITableViewCell, DarkModeBehaviour {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    @IBOutlet weak var starsView: CosmosView!
    
    private var preferredBackgroundColor : UIColor!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.mainView.clipsToBounds = true
        self.mainView.layer.cornerRadius = 5
        self.preferredBackgroundColor = self.mainView.backgroundColor
        
        DarkModeManager.shared.register(component: self)
        self.setDarkMode(enabled: Preferences.shared.getSwitch(for: .darkMode))
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setDarkMode(enabled: Bool) {
        
        self.mainView.backgroundColor = enabled ? .darkGray : self.preferredBackgroundColor
        
    }
    
}
