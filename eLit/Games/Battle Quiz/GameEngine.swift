//
//  GameEngine.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 12/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

enum GameOutcome {
    case win
    case loose
    case tie
}

protocol GameEngineDelegate {
    
    // Errors
    func gameWillStart(rounds : Int, localPlayerImage : UIImage, remotePlayerImage : UIImage)
    func gameDidAbort(reason value : String)
    func gameDidEnd(outcome : GameOutcome)
    
    // Remote notifications
    func remotePlayerDidDisconnect()
    
    // Round handling
    func roundDidStart(withQuestion question : String, answers : [String : Bool], image : UIImage, timeout : Int)
    func roundDidEnd(localAnswer : Bool, remoteAnswer : Bool)

}

class GameEngine: NSObject, GameControllerDelegate {
    
    // The GameController is gon be the delegate
    // It is even going to hold a reference to this object
    public var delegate : GameEngineDelegate!
    
    init(delegate : GameEngineDelegate) {
        super.init()
        
        self.delegate = delegate
        
        self.delegate.gameWillStart(rounds: 5, localPlayerImage: UIImage(named: "SearchBackground")!, remotePlayerImage: UIImage(named: "launchscreen")!)
        
        Model.shared.getDrinks()[0].getImage { (image) in
            self.delegate.roundDidStart(
                withQuestion: "What ingredient is present here?",
                answers: ["Ice" : true, "Mint" : false, "Vodka" : false, "Lime" : false],
                image: image,
                timeout: 10
            )
        }
    }
    
    func playerDidChooseAnswer(number: Int) {
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
            self.delegate.roundDidEnd(localAnswer: true, remoteAnswer: false)
        }
        
    }

}
