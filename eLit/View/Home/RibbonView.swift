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
    @IBInspectable var cornerRadius : CGFloat = 10
    @IBInspectable var borderAlpha : CGFloat = 0.4
    @IBInspectable var fillAlpha : CGFloat = 0.1
    @IBInspectable var initialAlpha : CGFloat = 0.0
    
    override func awakeFromNib() {
        self.alpha = initialAlpha
        setup()        
    }
    
    func setup () {
        
        self.layer.borderWidth = thinkness
        self.layer.cornerRadius = self.cornerRadius
        self.layer.borderColor = color.withAlphaComponent(borderAlpha).cgColor
        self.backgroundColor = color.withAlphaComponent(fillAlpha)
        
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
