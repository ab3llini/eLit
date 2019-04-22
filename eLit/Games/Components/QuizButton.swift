//
//  QuizButton.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 14/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

@IBDesignable
class QuizButton: UIButton, DarkModeBehaviour {

    @IBInspectable var neutralColor : UIColor = .blue
    @IBInspectable var selectedColor : UIColor = .yellow
    @IBInspectable var primaryColor : UIColor = .green
    @IBInspectable var secondaryColor : UIColor = .red
    
    @IBInspectable var bgAlpha : CGFloat = 0.5
    @IBInspectable var borderRadius : CGFloat = 20
    
    private var preferredTextColor : UIColor!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepare()
        self.preferredTextColor = self.titleLabel?.textColor
        DarkModeManager.shared.register(component: self)
    }
    
    func prepare() {
        self.clipsToBounds = true
        self.layer.borderColor = self.neutralColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = self.borderRadius
        self.backgroundColor = self.neutralColor.withAlphaComponent(self.bgAlpha)
        self.isUserInteractionEnabled = true
    }
    
    override func prepareForInterfaceBuilder() {
        self.prepare()
    }
    
    func changeTo(color : UIColor) {
        self.backgroundColor = color.withAlphaComponent(self.bgAlpha)
        self.layer.borderColor = color.cgColor
    }
    
    func setDarkMode(enabled: Bool) {
        self.setTitleColor((enabled) ? .white : self.preferredTextColor, for: .normal)
    }
    
}
