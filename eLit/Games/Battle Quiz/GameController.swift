//
//  GameController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 12/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

protocol GameControllerDelegate {
    func playerDidChooseAnswer(number : Int)
}


class GameController: UIViewController, GameEngineDelegate, ContextDelegate {
    
    // Game objects
    @IBOutlet var localPlayer: Player!
    @IBOutlet var remotePlayer: Player!
    @IBOutlet var context: Context!
    
    // Engine
    private var engine : GameEngine!
    
    // Delegate - Will be set to the game engine
    private var delegate : GameControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide the tab bar to make the game go full screen!
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupGameController()
    }
    
    // Called from parent view controller to init a new game!
    func setupGameController() {
        self.engine = GameEngine(delegate: self)
        self.delegate = self.engine
        self.context.delegate = self
    }
    
    func gameWillStart(rounds : Int, localPlayerImage : UIImage, remotePlayerImage : UIImage) {
        self.localPlayer.setNumberOfRounds(rounds)
        self.remotePlayer.setNumberOfRounds(rounds)
        self.localPlayer.setPlayerImage(localPlayerImage)
        self.remotePlayer.setPlayerImage(remotePlayerImage)
    }
    
    func gameDidAbort(reason value: String) {
        
    }
    
    func remotePlayerDidAnswer(_ value: Bool) {
        
    }
    
    func remotePlayerDidDisconnect() {
        
    }
    
    func roundDidStart(withQuestion question: String, answers: [String : Bool], image: UIImage, timeout: Int) {
        self.context.setQuestion(question)
        self.context.setAnswers(answers)
        self.context.setImage(image)
        self.context.startTimeout(duration: timeout)
    }
    
    func roundDidEnd(localAnswer : Bool, remoteAnswer : Bool) {
        self.context.revealAnswers()
        self.localPlayer.setWinCurrentRound(localAnswer)
        self.remotePlayer.setWinCurrentRound(remoteAnswer)
    }
    
    func gameDidEnd(outcome : GameOutcome) {
        
    }

    
    func playerDidSelect(answer: Int) {
        self.delegate.playerDidChooseAnswer(number: answer)
    }
    
    

}
