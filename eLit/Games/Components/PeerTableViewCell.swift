//
//  PeerTableViewCell.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 14/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol PeerTableViewCellDelegate {
    func peerCell(_ cell : PeerTableViewCell, didInvite peer : DiscoveredPeer)
}

class PeerTableViewCell: UITableViewCell {

    @IBOutlet weak var peerName: UILabel!
    @IBOutlet weak var challengeButton: QuizButton!
    @IBOutlet weak var peerImageView: UIImageView!
    
    private var peer : DiscoveredPeer!
    public var delegate : PeerTableViewCellDelegate?
    

    func setPeer(_ peer : DiscoveredPeer, lastInvited : DiscoveredPeer?, enabled : Bool) {
        
        // General cell cleaning after reuse
        challengeButton.setTitle("Invite", for: .normal)
        self.challengeButton.changeTo(color: self.challengeButton.neutralColor)
        self.challengeButton.isEnabled = enabled
        
        peer.getImage { (image) in
            self.peerImageView.image = image
            self.peerImageView.roundImage(with: 1, ofColor: .gray)

        }
        
        self.peer = peer
        self.peerName.text = (peer.peerName != nil ? peer.peerName! : peer.peerID.displayName)
        
        if let invited = lastInvited {
            if invited.peerID == peer.peerID {
                challengeButton.setTitle("Invited", for: .normal)
                self.challengeButton.changeTo(color: self.challengeButton.primaryColor)
            }
        }
    }

    @IBAction func onChallenge(_ sender: QuizButton) {
            
        sender.setTitle("Invited", for: .normal)
        sender.changeTo(color: sender.primaryColor)

        if let _ = self.delegate {
            self.delegate!.peerCell(self, didInvite: self.peer)
        }
    }
}
