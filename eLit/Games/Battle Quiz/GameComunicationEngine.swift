//
//  GameComunicationEngine.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 18/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class GameComunicationEngine: NSObject, ConnectionManagerGameCommunicationDelegate {


    private let mode: OperationMode
    private let questionGenerator: QuestionGenerator?
    private let cm = ConnectionManager.shared
    private var currentQuestion: Question?
    private var currentAnswer: String = "no-answer"
    private var correctAnswers : [String : Int] = ["host" : 0, "client" : 0]
    public var engine : GameEngine!
    
    
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
        self.checkIsCorrectAnswer(value, for: .host)
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
                self.questionHandlers = []
            }
        }
    }
    
    private func computeOutcomeFor(_ mode : OperationMode) -> GameOutcome {
        
        let lkey = (mode == .host) ? "host" : "client"
        let rkey = (mode == .host) ? "client" : "host"

        if self.correctAnswers[lkey]! > self.correctAnswers[rkey]! {
            return .win
        }
        else if self.correctAnswers[lkey]! == self.correctAnswers[rkey]! {
            return .tie
        }
        else {
            return .loose
        }
    }
    
    func getGameOutcome(completion: @escaping (_ outcome: GameOutcome) -> Void){
        // Compute the winner, if one exists
        if self.mode == .host {
            completion(self.computeOutcomeFor(.host))
        }
        else {
           self.cm.requestOutcome(then: completion)
        }
    }
    
    func getRemoteAnswer(then completion: @escaping (_ answer: String?) -> Void) {
        self.cm.askForAnswer { (remoteAnswer) in
            if (self.mode == .host) {
                self.checkIsCorrectAnswer(remoteAnswer, for: .client)
            }
            completion(remoteAnswer)
        }
    }
    
    private func checkIsCorrectAnswer(_ answer : String?, for mode : OperationMode) {
        
        let key = (mode == .host) ? "host" : "client"
        
        if let question = self.currentQuestion {
            if let answers = question.answers, let answer_ = answer {
                if let isCorrect = answers[answer_], isCorrect == true {
                    self.correctAnswers[key] = self.correctAnswers[key]! + 1
                }
            }
        }
        
    }
    
    func connectionManager(remotePeerDidDisconnect peerID: MCPeerID) {
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { (timer) in
            // We need these secs delay before chekcing!
            if !self.engine.gameDidEnd {
                self.engine.delegate.remotePlayerDidDisconnect()
            }
        }
    }
    
    func connectionManager(didReceive requestType: MPCRequestType, handler: ((Any) -> Void)?) {
        switch requestType {
        case .requestQuestion:
            self.getNextQuestion(then: handler!)
        case .requestAnswer:
            handler!(self.currentAnswer)
            self.currentAnswer = "no-answer"
        case .requestOutcome:
            let outcome = self.computeOutcomeFor(.client)
            handler!(outcome)
        default:
            return
        }
    }
}
