//
//  RibbonView.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 06/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit

@IBDesignable
class RibbonView: UIView {
    
    @IBInspectable var color : UIColor = UIColor.lightGray
    @IBInspectable var thinkness : CGFloat = 2
    
    override func awakeFromNib() {
        self.alpha = 0
        setup()        
    }
    
    func setup () {
        
        self.layer.borderWidth = thinkness
        self.layer.borderColor = color.withAlphaComponent(0.4).cgColor
        self.layer.cornerRadius = 10
        self.backgroundColor = color.withAlphaComponent(0.1)
        
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    func show() {
        
        setup()
        
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
        
    }
    
}
