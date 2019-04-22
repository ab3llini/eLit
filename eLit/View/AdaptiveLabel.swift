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

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        
        self.preferredColor = self.textColor
        DarkModeManager.shared.register(component: self)
        
    }
    
}
