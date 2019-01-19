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
    
    var textField : UITextField!
    
    
    override func awakeFromNib() {
        
        self.layer.cornerRadius = 5
        
        self.backgroundColor = UIColor.clear
                
        textField = UITextField(frame: self.bounds)
        textField.backgroundColor = UIColor.clear
        textField.font = UIFont(name: "HelveticaNeue", size: 11)
        textField.textColor = UIColor.black
        textField.textAlignment = .center
        
        self.addSubview(textField)
        
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
