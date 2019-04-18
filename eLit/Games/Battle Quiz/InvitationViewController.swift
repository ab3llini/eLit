//
//  InvitationViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 14/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class InvitationViewController: UIViewController, TimeoutLabelDelegate {

    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var coutdownLabel: TimeoutLabel!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var declineButton: QuizButton!
    @IBOutlet weak var acceptButton: QuizButton!
    
    private var invite : UIInvite!
    private var didChoose = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playerImage.roundImage(with: 1, ofColor: .gray)
        coutdownLabel.delegate = self
    }
    
    func timeoutDidExpire() {
        if (self.didChoose == false) {
            self.invite.handler(false)
            self.performSegue(withIdentifier: Navigation.toBattleQuizVC.rawValue, sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.didChoose = false
        
        //self.playerImage.image = currentContext.peer.image
        self.playerName.text = self.invite.origin.displayName
        
        acceptButton.isUserInteractionEnabled = true
        acceptButton.isHidden = false
        acceptButton.changeTo(color: acceptButton.neutralColor)
        
        declineButton.changeTo(color: declineButton.neutralColor)
        declineButton.isUserInteractionEnabled = true
        declineButton.isHidden = false
        
        self.coutdownLabel.isHidden = false
        self.coutdownLabel.startTimeout(duration: 30)

    }
    
    
    
    @IBAction func onAcceptInvitation(_ sender: QuizButton) {
        self.invite.handler(true)
        sender.changeTo(color: sender.primaryColor)
        sender.isUserInteractionEnabled = false
        declineButton.isHidden = true
        handleSelection(accepted: true)

    }
    
    @IBAction func onDeclineInvitation(_ sender: QuizButton) {
        self.invite.handler(false)

        sender.changeTo(color: sender.secondaryColor)
        sender.isUserInteractionEnabled = false
        acceptButton.isHidden = true
        handleSelection(accepted: false)

    }
    
    private func handleSelection(accepted : Bool) {
        self.didChoose = true
        self.coutdownLabel.stopChanging()
        self.coutdownLabel.isHidden = true
        if !accepted {
            self.performSegue(withIdentifier: Navigation.toBattleQuizVC.rawValue, sender: self)
        }
        
    }
    
    func set(_ invite : UIInvite) {
        self.invite = invite
    }
    
}
