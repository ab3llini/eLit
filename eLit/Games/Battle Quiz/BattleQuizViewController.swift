//
//  BattleQuizViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 02/03/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class BattleQuizViewController: UIViewController, NearbyBrowserTableViewDelegate, ConnectionManagerDelegate {
    
    @IBOutlet weak var nearbyBrowserTableView: NearbyBrowserTableView!
    @IBOutlet weak var statuslabel: UILabel!
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView!

    private var connectionManager : ConnectionManager = ConnectionManager.shared
    
    private var invite : Invite?
    
    override func viewDidLoad() {
        
        print("View did load")
        
        super.viewDidLoad()
        
        ConnectionManager.shared.delegate = self
        ConnectionManager.shared.start()
        
        self.nearbyBrowserTableView.browserDelegate = self
        
    }
    
    func connectionManager(didReceive invite : Invite) {
        self.invite = invite
        self.performSegue(withIdentifier: Navigation.toInviteVC.rawValue, sender: self)
    }
    
    func connectionManager(foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        self.nearbyBrowserTableView.update(peers: self.connectionManager.discovered)
    }
    
    func connectionManager(lostPeer peerID: MCPeerID) {
        self.nearbyBrowserTableView.update(peers: self.connectionManager.discovered)
    }
    
    func connectionManager(peer: MCPeerID, didRefuseInvite: Invite) {
        
    }
    
    func connectionManager(peer: MCPeerID, didAcceptInvite: Invite) {
        
    }
    
    func browserTableView(_ browserTableView: NearbyBrowserTableView, cell: PeerTableViewCell, didInvite peer: MCPeerID) {
        self.connectionManager.invite(peer)
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
    
    func connectionManager(peer: MCPeerID, didAcceptInvite: Bool) {
        
    }
    
    func connectionManager(peer: MCPeerID, connectedTo session: MCSession, with operationMode: OperationMode) {
        
    }
}
