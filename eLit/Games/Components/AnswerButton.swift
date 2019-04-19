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
    
    func setIsCorrectAnswer() {
        self.isCorrectAnswer = true
    }
    
    func setSelected() {
        self.hasBeenSelected = true
        self.changeTo(color: self.selectedColor)
    }
    
    func revealAnswer() {
        
        if (self.isCorrectAnswer) {
            self.changeTo(color: self.primaryColor)

        }
        else if (self.hasBeenSelected && !self.isCorrectAnswer) {
            self.changeTo(color: self.secondaryColor)
        }
        
    }
    
}
