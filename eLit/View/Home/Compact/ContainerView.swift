//
//  ColorMask.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 06/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit

class ContainerView: UIView {
    
    @IBInspectable public var borderRadius : CGFloat = 0

    override func awakeFromNib() {
        self.layer.cornerRadius = borderRadius
    }
    

}

