//
//  GameController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 12/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

protocol GameControllerDelegate {
    func playerDidChoose(answer : String)
    func timeoutDidExpire()
}


class GameViewController: UIViewController, GameEngineDelegate, ContextDelegate {
    
    
    // Game objects
    @IBOutlet var localPlayer: Player!
    @IBOutlet var remotePlayer: Player!
    @IBOutlet var context: Context!
    
    private var outcome : GameOutcome?
    
    // Engine
    private var engine : GameEngine!
    
    // Delegate - Will be set to the game engine
    private var delegate : GameControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide the tab bar to make the game go full screen!
        self.tabBarController?.tabBar.isHidden = true
        self.context.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.engine.start()
    }
    
    // Called from parent view controller to init a new game!
    func setupGameController(with opMode: OperationMode) {
        self.engine = GameEngine(with: opMode, delegate: self)
        self.delegate = self.engine
    }
    
    func gameWillStart(rounds : Int, localPlayerImage : UIImage, remotePlayerImage : UIImage) {
        self.localPlayer.setNumberOfRounds(rounds)
        self.remotePlayer.setNumberOfRounds(rounds)
        self.localPlayer.setPlayerImage(localPlayerImage)
        self.remotePlayer.setPlayerImage(remotePlayerImage)
    }
    
    func gameDidAbort(reason value: String) {
        self.outcome = nil
        self.performSegue(withIdentifier: Navigation.toGameOutcomeVC.rawValue, sender: self)
    }
    
    func remotePlayerDidDisconnect() {
        self.outcome = .win
        self.performSegue(withIdentifier: Navigation.toGameOutcomeVC.rawValue, sender: self)
    }
    
    func roundDidStart(withQuestion question: Question) {
        if let question_ = question.question {
            self.context.setQuestion(question_)
        }
        if let answers_ = question.answers {
            self.context.setAnswers(answers_)
        }
        
        question.getImage(then: { image in
            self.context.setImage(image)
        })
        
        self.context.startTimeout(duration: question.timeout)
    }
    
    func roundDidEnd(localAnswer : Bool, remoteAnswer : Bool) {
        self.context.revealAnswers()
        self.localPlayer.setWinCurrentRound(localAnswer)
        self.remotePlayer.setWinCurrentRound(remoteAnswer)
    }
    
    func gameDidEnd(outcome : GameOutcome) {
        self.outcome = outcome
        self.performSegue(withIdentifier: Navigation.toGameOutcomeVC.rawValue, sender: self)
    }

    
    func playerDidChoose(answer: String) {
        self.delegate.playerDidChoose(answer: answer)
    }
    
    func timeoutDidExpire() {
        self.delegate.timeoutDidExpire()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case Navigation.toGameOutcomeVC.rawValue:
            (segue.destination as! OutcomeViewController).outcome = self.outcome
        default:
            return
        }
    }

}
