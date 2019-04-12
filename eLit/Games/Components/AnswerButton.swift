//
//  AsnwerButton.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 12/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

@IBDesignable class AnswerButton: UIButton {
    
    private var isCorrectAnswer : Bool = false
    private var hasBeenSelected : Bool = false
    
    @IBInspectable var neutralColor : UIColor = .blue
    @IBInspectable var selectedColor : UIColor = .yellow
    @IBInspectable var primaryColor : UIColor = .green
    @IBInspectable var secondaryColor : UIColor = .red
    @IBInspectable var bgAlpha : CGFloat = 0.2
    
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
    
    func setIsCorrectAnswer() {
        self.isCorrectAnswer = true
    }
    
    func setSelected() {
        self.hasBeenSelected = true
        self.backgroundColor = self.selectedColor.withAlphaComponent(self.bgAlpha)
        self.layer.borderColor = self.selectedColor.cgColor
    }
    
    func revealAnswer() {
        
        if (self.isCorrectAnswer) {
            self.backgroundColor = self.primaryColor.withAlphaComponent(self.bgAlpha)
            self.layer.borderColor = self.primaryColor.cgColor
        }
        else if (self.hasBeenSelected && !self.isCorrectAnswer) {
            self.backgroundColor = self.secondaryColor.withAlphaComponent(self.bgAlpha)
            self.layer.borderColor = self.secondaryColor.cgColor
        }
        
    }
    
}
