
//
//  Question.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 12/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

protocol ContextDelegate {
    func playerDidSelect(answer : Int)
}

class Context: NSObject {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var question: UILabel!
    @IBOutlet var answerButtons: [AnswerButton]!
    @IBOutlet weak var timeoutLabel: TimeoutLabel!

    public var delegate: ContextDelegate?
    
    func setAnswers(_ values : [String : Bool]) {
        
        if (values.count != answerButtons.count) {
            return
        }
        
        var current = 0
        for (string, value) in values {
            answerButtons[current].prepare()
            answerButtons[current].setTitle(string, for: .normal)
            if (value) {
                answerButtons[current].setIsCorrectAnswer()
            }
            answerButtons[current].isHidden = false
            current += 1

        }
    }
    
    func setQuestion(_ value : String) {
        self.question.text = value
    }
    
    func setImage(_ value : UIImage?) {
        self.imageView.image = value
    }
    
    func startTimeout(duration : Int) {
        self.timeoutLabel.isHidden = false
        self.timeoutLabel.startTimeout(duration: duration)
    }
    
    func revealAnswers() {
        for button in self.answerButtons {
            button.revealAnswer()
        }
    }
    
    @IBAction func onAnswerSelection(_ sender: AnswerButton) {
        sender.setSelected()
        
        for button in self.answerButtons {
            // Disable interactions from now on!
            button.isUserInteractionEnabled = false
        }
        
        if let callback = self.delegate {
            callback.playerDidSelect(answer : sender.tag)
        }
    }
    
    
}
