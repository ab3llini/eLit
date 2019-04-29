//
//  GameEngine.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 12/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

enum GameOutcome : String {
    case win = "You won!"
    case loose = "You lost!"
    case tie = "Tie!"
    case disconnect = "Other player left"
    case error = "An error occured.."
}

protocol GameEngineDelegate {
    
    // Errors
    func gameWillStart(rounds : Int)
    func gameDidAbort(reason value : String)
    func gameDidEnd(outcome : GameOutcome)
    
    // Remote notifications
    func remotePlayerDidDisconnect()
    
    // Round handling
    func roundDidStart(withQuestion question : Question)
    func roundDidEnd(localAnswer : Bool, remoteAnswer : Bool)

}


class GameEngine: NSObject, GameControllerDelegate {
    // The GameController is gon be the delegate
    // It is even going to hold a reference to this object
    public var delegate : GameEngineDelegate!
    private let netMode: OperationMode
    private let rounds = 2
    private let communicationEngine: GameComunicationEngine
    private var currentAnswer: String?
    private var currentQuestion: Question?
    public private(set) var gameDidEnd = false
    
    private var round = 0
    
    init(with mode: OperationMode, delegate : GameEngineDelegate) {
        self.netMode = mode
        self.communicationEngine = GameComunicationEngine(for: mode)
        
        super.init()
        self.communicationEngine.engine = self
        self.delegate = delegate
        ConnectionManager.shared.gameCommunicationDelegate = self.communicationEngine
    }
    
    func start() {
        self.delegate.gameWillStart(rounds: self.rounds)
        self.nextRound()
    }
    
    func playerDidChoose(answer : String) {
        self.currentAnswer = answer
        self.communicationEngine.setLastAnswer(to: answer)
    }

    func timeoutDidExpire() {
        
        self.nextRound(uponReceivingQuestion: { (question) in
            
            self.communicationEngine.getRemoteAnswer(then: { answer in
                
                var current: Bool = false
                if self.currentAnswer != nil {
                    current = self.currentQuestion!.answers![self.currentAnswer!]!
                    if current && self.netMode == .host {
                        self.communicationEngine.correctAnswers["host"] = self.communicationEngine.correctAnswers["host"]! + 1
                    }
                }
                var remote: Bool = false
                if answer != nil {
                    if let choice = self.currentQuestion?.answers![answer!] {
                        remote = choice
                        if remote && self.netMode == .host {
                            self.communicationEngine.correctAnswers["client"] = self.communicationEngine.correctAnswers["client"]! + 1
                        }
                    }
                }
                
                
                
                self.delegate.roundDidEnd(localAnswer: current, remoteAnswer: remote)
                self.currentQuestion = question
                self.currentAnswer = nil
                
                if self.round <= self.rounds {
                    Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (timer) in
                        self.delegate.roundDidStart(withQuestion: self.currentQuestion!)
                    })
                } else {
                    self.gameDidEnd = true
                    self.communicationEngine.getGameOutcome(completion: { (outcome) in
                        Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (timer) in
                            self.delegate.gameDidEnd(outcome: outcome)
                        })
                    })
                }
            })
        })
    }
    
    private func nextRound(uponReceivingQuestion call : ((_ question: Question?) -> Void)? = nil) {
        
        self.round += 1
        
        self.communicationEngine.getNextQuestion(then: { question in
            if let block = call {
                block(question)
            }
            else {
                self.currentQuestion = question
                self.delegate.roundDidStart(withQuestion: question!)
            }
        })
    }
}
