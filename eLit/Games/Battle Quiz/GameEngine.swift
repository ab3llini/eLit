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
    
    private var round = 0
    
    init(with mode: OperationMode, delegate : GameEngineDelegate) {
        self.netMode = mode
        self.comunicationEngine = GameComunicationEngine(for: mode)
        
        super.init()
        self.delegate = delegate
        self.delegate.gameWillStart(rounds: self.rounds, localPlayerImage: UIImage(), remotePlayerImage: UIImage())
        self.nextRound()
    }
    
    func playerDidChoose(answer : String) {

        print("This event is raised when the user selects an answer.")
        
    }

    func timeoutDidExpire() {
        print("This event is raised when the match timeout expires.")
    }
    
    private func nextRound() {
        self.comunicationEngine.getNextQuestion(then: { question in
            self.delegate.roundDidStart(withQuestion: question!)
        })
    }
}
