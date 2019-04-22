//
//  InvitationViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 14/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class InvitationViewController: BlurredBackgroundViewController, TimeoutLabelDelegate {

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
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        
        // Hide the tab bar to make the game go full screen!
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
        self.didChoose = false
        
        if let name = self.invite.origin.peerName {
            self.playerName.text = name
        }
        else {
            self.playerName.text = self.invite.origin.peerID.displayName
        }
        
        self.invite.origin.getImage { (image) in
            self.playerImage.image = image
        }
        
        acceptButton.isUserInteractionEnabled = true
        acceptButton.isHidden = false
        acceptButton.changeTo(color: acceptButton.neutralColor)
        declineButton.changeTo(color: declineButton.neutralColor)
        declineButton.isUserInteractionEnabled = true
        declineButton.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        self.coutdownLabel.startTimeout(duration: 30)
    }
    
    func timeoutDidExpire() {
        if (self.didChoose == false) {
            self.invite.handler(false)
            self.performSegue(withIdentifier: Navigation.toBattleQuizVC.rawValue, sender: self)
        }
    }
    
    @IBAction func onAcceptInvitation(_ sender: QuizButton) {
        self.invite.handler(true)
        sender.changeTo(color: sender.primaryColor)
        sender.isUserInteractionEnabled = false
        declineButton.isHidden = true
        handleSelection(accepted: true)
        ConnectionManager.shared.stop()
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
        if !accepted {
            self.performSegue(withIdentifier: Navigation.toBattleQuizVC.rawValue, sender: self)
        }
        
    }
    
    func set(_ invite : UIInvite) {
        self.invite = invite
        
    }
    
}
