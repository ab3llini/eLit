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
}

protocol GameEngineDelegate {
    
    // Errors
    func gameWillStart(rounds : Int, localPlayerImage : UIImage, remotePlayerImage : UIImage)
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
    private let rounds = 5
    private let comunicationEngine: GameComunicationEngine
    private var currentAnswer: String?
    private var currentQuestion: Question?
    
    private var round = 0
    
    init(with mode: OperationMode, delegate : GameEngineDelegate) {
        self.netMode = mode
        self.comunicationEngine = GameComunicationEngine(for: mode)
        
        super.init()
        self.delegate = delegate
        ConnectionManager.shared.gameCommunicationDelegate = self.comunicationEngine
    }
    
    func start() {
        self.delegate.gameWillStart(rounds: self.rounds, localPlayerImage: UIImage(), remotePlayerImage: UIImage())
        self.nextRound()
    }
    
    func playerDidChoose(answer : String) {
        self.currentAnswer = answer
    }

    func timeoutDidExpire() {
        
        self.nextRound(uponReceivingQuestion: { (question) in
            
            self.comunicationEngine.getRemoteAnswer(then: { answer in
                
                var current: Bool = false
                if self.currentAnswer != nil {
                    current = self.currentQuestion!.answers![self.currentAnswer!]!
                }
                var remote: Bool = false
                if answer != nil {
                    if let choice = self.currentQuestion?.answers![answer!] {
                        remote = choice
                    }
                }
                self.delegate.roundDidEnd(localAnswer: current, remoteAnswer: remote)
                
                self.currentQuestion = question
                self.currentAnswer = nil
                
                Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (timer) in
                    // Inception
                    self.delegate.roundDidStart(withQuestion: self.currentQuestion!)
                })
                
            })
        })
    }
    
    private func nextRound(uponReceivingQuestion call : ((_ question: Question?) -> Void)? = nil) {
        self.round += 1
        if self.round <= self.rounds {
            self.comunicationEngine.getNextQuestion(then: { question in
                if let block = call {
                    block(question)
                }
                else {
                    self.currentQuestion = question
                    self.delegate.roundDidStart(withQuestion: question!)
                }
            })
        } else {
            // TODO: game outcome
        }
    }
}