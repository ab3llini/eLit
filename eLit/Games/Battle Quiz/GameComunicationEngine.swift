//
//  GameComunicationEngine.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 18/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit


class GameComunicationEngine: NSObject, ConnectionManagerGameCommunicationDelegate {
    
    private let mode: OperationMode
    private let questionGenerator: QuestionGenerator?
    private let cm = ConnectionManager.shared
    private var currentQuestion: Question?
    private var currentAnswer: String = "no-answer"

    
    private var questionHandlers : [((_ question: Question?) -> Void)] = []
    
    init (for mode: OperationMode) {
        self.mode = mode
        if mode == .host {
            self.questionGenerator = QuestionGenerator()
        } else {
            self.questionGenerator = nil
        }
        
        super.init()
    }
    
    func setLastAnswer(to value : String) {
        self.currentAnswer = value
    }
    
    func getNextQuestion(then completion: @escaping (_ question: Question?) -> Void) {
        
        if self.mode == .client {
            self.cm.requestQuestion(then: completion)
        }
        else {
            // I am the ho$t
            if self.questionHandlers.count == 0 {
                self.questionHandlers.append(completion)
                self.currentQuestion = self.questionGenerator?.getQuestion()
            }
            else {
                self.questionHandlers.append(completion)
                for handler in self.questionHandlers {
                    handler(self.currentQuestion)
                }
                self.currentQuestion = nil
                self.questionHandlers = []
            }
        }
    }
    
    func getRemoteAnswer(then completion: @escaping (_ answer: String?) -> Void) {
        self.cm.askForAnswer(then: completion)
    }
    
    func connectionManager(didReceive requestType: MPCRequestType, handler: ((Any) -> Void)?) {
        switch requestType {
        case .requestQuestion:
            self.getNextQuestion(then: handler!)
        case .requestAnswer:
            handler!(self.currentAnswer)
            self.currentAnswer = "no-answer"
        default:
            return
        }
    }
}
