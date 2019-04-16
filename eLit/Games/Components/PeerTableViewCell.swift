//
//  PeerTableViewCell.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 14/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class PeerTableViewCell: UITableViewCell {

    @IBOutlet weak var peerName: UILabel!
    @IBOutlet weak var challengeButton: QuizButton!
    @IBOutlet weak var peerImageView: UIImageView!
    
    private var peerID : MCPeerID!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.peerImageView.roundImage(with: 1, ofColor: .gray)
    }

    
    func setPeer(_ peer : MCPeerID) {
        
        
        self.peerID = peer
        //self.peerID = peer.id
        self.peerName.text = peer.displayName
        
//        if peer.image == nil {
//            if let url = peer.imageURL {
//                UIImage.downloadImage(from: url) { (image) in
//                    self.peerImageView.image = image
//                    peer.image = image
//                }
//            }
//        }
//        else {
//            self.peerImageView.image = peer.image
//        }
    }

    @IBAction func onChallenge(_ sender: QuizButton) {
        
        sender.setTitle("Invited \(self.peerID)", for: .normal)
        sender.changeTo(color: sender.primaryColor)
        sender.isUserInteractionEnabled = false

        ConnectionManager.shared.invite(self.peerID)
        
        Timer.scheduledTimer(withTimeInterval: ConnectionManager.shared.ACCEPT_TIMEOUT, repeats: false) { (timer) in
            sender.setTitle("Invite", for: .normal)
            sender.changeTo(color: sender.neutralColor)
            sender.isUserInteractionEnabled = true
        }
    }
}
