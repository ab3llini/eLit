//
//  GameComunicationEngine.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 18/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class GameComunicationEngine: NSObject {
    

    private let mode: OperationMode
    private let questionGenerator: QuestionGenerator?
    private let cm = ConnectionManager.shared
    
    init (for mode: OperationMode) {
        self.mode = mode
        if mode == .host {
            self.questionGenerator = QuestionGenerator()
        } else {
            self.questionGenerator = nil
        }
        
        super.init()
    }
    
    func getNextQuestion(then completion: @escaping (_ question: Question?) -> Void) {
        switch self.mode {
        case .host:
            let question = self.questionGenerator?.getQuestion()
            completion(question)
        case .client:
            self.cm.requestQuestion(then: completion)
        }
    }
    
    func getRemoteAnswer(then completion: (_ answer: String?) -> Void) {
        self.cm.askForAnswer(then: completion)
    }
}
