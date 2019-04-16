//
//  BattleQuizViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 02/03/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class BattleQuizViewController: UIViewController, ConnectionManagerUIDelegate {
    
    @IBOutlet weak var nearbyBrowserTableView: NearbyBrowserTableView!
    @IBOutlet weak var statuslabel: UILabel!
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView!

    private var invite : Invite?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConnectionManager.shared.uiDelegate = self
    }
    
    func connectionManager(didReceive invite : Invite) {
        self.invite = invite
        self.performSegue(withIdentifier: Navigation.toInviteVC.rawValue, sender: self)
    }
    
    func connectionManager(foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        self.nearbyBrowserTableView.updatePeers()
    }
    
    func connectionManager(lostPeer peerID: MCPeerID) {
        self.nearbyBrowserTableView.updatePeers()
    }
    
    func connectionManager(peer: MCPeerID, didRefuseInvite: Invite) {
        
    }
    
    func connectionManager(peer: MCPeerID, didAcceptInvite: Invite) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Navigation.toInviteVC.rawValue:
            if let _invite = self.invite {
                (segue.destination as! InvitationViewController).set(_invite)
            }
        default:
            return
        }
    }
}
