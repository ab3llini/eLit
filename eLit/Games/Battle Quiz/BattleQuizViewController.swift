//
//  BattleQuizViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 02/03/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import MultipeerConnectivity

struct InviteContext {
    var peer : Peer
    var invite : Invite
    var manager : ConnectionManager
}

class BattleQuizViewController: UIViewController, ConnectionManagerUIDelegate {
    
    @IBOutlet weak var nearbyBrowserTableView: NearbyBrowserTableView!
    @IBOutlet weak var statuslabel: UILabel!
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView!
    
    public var currentInviteContext : InviteContext?
    private var initialized : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        

        // Reset ALWAYS the current invitation context
        self.currentInviteContext = nil
        
        // Advertise
        if !ConnectionManager.shared.isLoggedIn() {
            self.statuslabel.text = "Please login first!"
            self.statusIndicator.isHidden = true
        }
        else {
            self.statuslabel.text = "Looking for players.."
            self.statusIndicator.isHidden = false
            
            ConnectionManager.shared.uiDelegate = self
        }
    }
    
    func connectionManager(_ manager : ConnectionManager, didReceive invite : Invite) {
        
        if let inviter = self.nearbyBrowserTableView.getPeer(invite.origin) {
            self.currentInviteContext = InviteContext(peer: inviter, invite: invite, manager: manager)
            self.performSegue(withIdentifier: Navigation.toInviteVC.rawValue, sender: self)
        }
    }
    
    func connectionManager(_ manager: ConnectionManager, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        self.nearbyBrowserTableView.updatePeers()
    }
    
    func connectionManager(_ manager: ConnectionManager, lostPeer peerID: MCPeerID) {
        self.nearbyBrowserTableView.updatePeers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Navigation.toInviteVC.rawValue:
            if let context = self.currentInviteContext {
                (segue.destination as! InvitationViewController).prepareWith(context: context)
            }
        default:
            return
        }
    }
}
