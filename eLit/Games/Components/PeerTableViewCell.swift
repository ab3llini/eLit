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
    func peerCell(_ cell : PeerTableViewCell, didInvite peer : MCPeerID)
}

class PeerTableViewCell: UITableViewCell {

    @IBOutlet weak var peerName: UILabel!
    @IBOutlet weak var challengeButton: QuizButton!
    @IBOutlet weak var peerImageView: UIImageView!
    
    private var peerID : MCPeerID!
    public var delegate : PeerTableViewCellDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.peerImageView.roundImage(with: 1, ofColor: .gray)
    }

    func setPeer(_ peer : DiscoveredPeer) {
        
        
        self.peerID = peer.peerID
        //self.peerID = peer.id
        self.peerName.text = peer.peerID.displayName
        
    }

    @IBAction func onChallenge(_ sender: QuizButton) {
        
        sender.setTitle("Invited", for: .normal)
        sender.changeTo(color: sender.primaryColor)
        sender.isUserInteractionEnabled = false

        if let _ = self.delegate {
            self.delegate!.peerCell(self, didInvite: self.peerID)
        }
    }
}
