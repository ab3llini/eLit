//
//  QuizButton.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 14/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

@IBDesignable
class QuizButton: UIButton {

    @IBInspectable var neutralColor : UIColor = .blue
    @IBInspectable var bgAlpha : CGFloat = 0.5


    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepare()
    }
    
    func prepare() {
        self.clipsToBounds = true
        self.layer.borderColor = self.neutralColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 20
        self.backgroundColor = self.neutralColor.withAlphaComponent(self.bgAlpha)
        self.isUserInteractionEnabled = true
    }
    
    override func prepareForInterfaceBuilder() {
        self.prepare()
    }
    
}
