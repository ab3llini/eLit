//
//  BattleQuizViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 02/03/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class BattleQuizViewController: BlurredBackgroundViewController, NearbyBrowserTableViewDelegate, ConnectionManagerDelegate {
    
    @IBOutlet weak var nearbyBrowserTableView: NearbyBrowserTableView!
    @IBOutlet weak var statuslabel: UILabel!
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView!
    @IBOutlet weak var quizIcon: UIImageView!
    
    private var connectionManager : ConnectionManager = ConnectionManager.shared
    
    private var invite : UIInvite?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ConnectionManager.shared.delegate = self
        self.nearbyBrowserTableView.browserDelegate = self
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Hide the tab bar to make the game go full screen!
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        self.nearbyBrowserTableView.setInvitesEnabled(true)
        ConnectionManager.shared.start()
        self.nearbyBrowserTableView.update(peers: ConnectionManager.shared.discovered)

    }
    
    func connectionManager(didReceive invite : UIInvite) {
        self.invite = invite
        self.performSegue(withIdentifier: Navigation.toInviteVC.rawValue, sender: self)
    }
    
    func connectionManager(foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        self.nearbyBrowserTableView.update(peers: self.connectionManager.discovered)
    }
    
    func connectionManager(lostPeer peerID: MCPeerID) {
        self.nearbyBrowserTableView.update(peers: self.connectionManager.discovered)
    }
    
    func connectionManager(peer: MCPeerID, didAcceptInvite: Bool) {
        if !didAcceptInvite {
            self.nearbyBrowserTableView.setInvitesEnabled(true)
        }
    }
    
    func connectionManager(peer: MCPeerID, connectedTo session: MCSession, with operationMode: OperationMode) {
        self.performSegue(withIdentifier: Navigation.toGameVC.rawValue, sender: self)
    }
    
    func browserTableView(_ browserTableView: NearbyBrowserTableView, cell: PeerTableViewCell, didInvite peer: DiscoveredPeer) {
        self.connectionManager.invite(peer.peerID)
    }
    
    override func setDarkMode(enabled: Bool) {
        if enabled {
            self.quizIcon.tintColor = .white
        }
        else {
            self.quizIcon.tintColor = .black
        }
        super.setDarkMode(enabled: enabled)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Navigation.toInviteVC.rawValue:
            if let _invite = self.invite {
                (segue.destination as! InvitationViewController).set(_invite)
            }
        case Navigation.toGameVC.rawValue:
            let gameVC = segue.destination as! GameViewController
            gameVC.setupGameController(with: self.connectionManager.operationMode!)
        default:
            return
        }
    }
}
