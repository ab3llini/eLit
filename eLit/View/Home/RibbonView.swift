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
    
    var label : UILabel!
    
    
    override func awakeFromNib() {
        
        self.layer.cornerRadius = 5
        
        self.backgroundColor = UIColor.clear
                
        label = UILabel(frame: self.bounds)
        label.backgroundColor = UIColor.clear
        label.font = UIFont(name: "HelveticaNeue", size: 11)
        label.textColor = UIColor.black
        label.textAlignment = .center
        
        self.addSubview(label)
        
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        let label = UILabel(frame: self.bounds)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 8)
        label.text = "Ribbon"
        self.addSubview(label)
    }
    
    
}
