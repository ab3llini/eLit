//
//  AsnwerButton.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 12/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

@IBDesignable
class AnswerButton: QuizButton {
    
    private var isCorrectAnswer : Bool = false
    private var hasBeenSelected : Bool = false
    
    @IBInspectable var selectedColor : UIColor = .yellow
    @IBInspectable var primaryColor : UIColor = .green
    @IBInspectable var secondaryColor : UIColor = .red
    
    
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
