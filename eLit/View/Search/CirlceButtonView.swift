//
//  CirlceButtonView.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 28/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

@IBDesignable
class CirlceButtonView: UIView {

    @IBInspectable var color : UIColor = UIColor(red: 236/255, green: 69/255, blue: 90/255, alpha: 1)
    @IBInspectable var thickness : CGFloat = 2
    
    override func awakeFromNib() {
        
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = thickness
        self.layer.cornerRadius = self.bounds.width / 2
        
    }

}
