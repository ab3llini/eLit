
//
//  Player.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 12/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit


class Player: NSObject {

    @IBOutlet weak var playerImageView: PlayerImageView!
    
    private var nRounds : Int = 0
    private var rounds : [Bool] = []
    
    func setNumberOfRounds(_ number : Int) {
        self.nRounds = (number > 0) ? number : 0
        self.playerImageView.steps = self.nRounds
    }
    
    func setPlayerImage(_ image : UIImage) {
        self.playerImageView.clearView()
        self.playerImageView.setImage(to: image) 
    }
    
    func setWinCurrentRound(_ success : Bool) {
        if (self.rounds.count <= self.nRounds) {
            self.playerImageView.addNewArc(at: self.rounds.count, success: success)
            self.rounds.append(success)
        }
    }
    
}
