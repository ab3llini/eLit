//
//  File.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 11/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import Foundation
import Cosmos

class AdaptiveRating : CosmosView {
    
    @IBInspectable var regularSize : Double = 25
    
    override func layoutSubviews() {
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular {
            self.settings.starSize = regularSize
        }
        super.layoutSubviews()

    }
    
}
