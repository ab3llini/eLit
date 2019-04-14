//
//  MPCHandler.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 10/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import GoogleSignIn

// Important note: The table view that displays peers should take care of registering itself
// as delegate of the browser. Moreover it should handle start/stop browsing & start/stop advertising.

class Peer {
    var image : UIImage?
    var imageURL : URL?
    var id : MCPeerID
    
    init(imageURL : URL? , id : MCPeerID) {
        self.imageURL = imageURL
        self.id = id
    }
}

struct Invite {
    var origin : MCPeerID
    var handler : (Bool, MCSession?) -> Void
}

protocol ConnectionManagerUIDelegate {
    func connectionManager(_ manager : ConnectionManager, didReceive invite : Invite)
    func connectionManager(_ manager : ConnectionManager, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?)
    func connectionManager(_ manager : ConnectionManager, lostPeer peerID: MCPeerID)
}

class ConnectionManager: NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    
    public static let shared = ConnectionManager()
    
    public var browser :   MCNearbyServiceBrowser!
    public var session:    MCSession!
    public var advertiser: MCNearbyServiceAdvertiser!
    
    public var discovered : [Peer] = []
    
    private var isAdvertising = false
    private var isBrowsing = false


    private let SERVICE :   String = "BattleQuiz"
    public let ACCEPT_TIMEOUT : TimeInterval = 30.0
    
    // Delegates
    public var uiDelegate : ConnectionManagerUIDelegate?
    
    public func isLoggedIn() -> Bool {
        if let gid = GIDSignIn.sharedInstance() {
            if gid.hasAuthInKeychain() {
                return true
            }
        }
        return false
    }
    
    // Call this method always after each match!!!
    public func prepareToCommunicate() {
        
        self.discovered = []
        self.isBrowsing = false
        self.isAdvertising = false
        
        self.advertiser = nil
        self.session = nil
        self.browser = nil
        
        // Allow init only if user has authenticated
        if self.isLoggedIn() {
            // Initialize Browser -> It holds a reference to myPeerId
            self.browser = MCNearbyServiceBrowser(peer: MCPeerID(displayName: Model.shared.user!.name!), serviceType: SERVICE)
            self.session = MCSession(peer: self.browser.myPeerID)
            
            // Remember to setup browser delegate when using shared instance :)
            // Session delegate might be overwritten in the future
            self.session.delegate = self
        }
    }
    
    
    public func startAdvertising() {
        
        // Allow advertising only if user has authenticated
        if self.isLoggedIn() {
            // Prepare info
            let info : [String : String] = ["peerImageURL" : Model.shared.user!.imageURLString!]
            // Setup advertiser.
            self.advertiser = MCNearbyServiceAdvertiser(peer: self.browser.myPeerID, discoveryInfo: info, serviceType: SERVICE)
            
            // Setup delegate
            self.advertiser.delegate = self
            
            // Start advertising, passing user image ad user info
            self.advertiser.startAdvertisingPeer()
            
            self.isAdvertising = true
            
        }
    }
    
    public func stopAdvertising() {
        if self.advertiser != nil {
            self.advertiser.stopAdvertisingPeer()
            self.isAdvertising = false
        }
    }
    
    public func startBrowsing() {
        if self.isLoggedIn() {
            if self.browser != nil {
                self.browser.delegate = self
                self.browser.startBrowsingForPeers()
                self.isBrowsing = true
            }
        }
    }
    
    public func updateBrowserDelegate(delegate : MCNearbyServiceBrowserDelegate) {
        if self.isLoggedIn() && self.browser != nil && self.isBrowsing {
            self.browser.delegate = delegate
        }
    }
    
    public func isRunning () -> Bool {
        return self.isAdvertising && self.isBrowsing
    }
    
    public func stopBrowsing() {
        if self.browser != nil {
            self.browser.stopBrowsingForPeers()
            self.isBrowsing = false
        }
    }
    
    public func invitePeer(peerID : MCPeerID) {
        if self.isLoggedIn() {
            
            let context = "Host".data(using: .utf8)
            self.browser.invitePeer(peerID, to: self.session, withContext: context, timeout: ACCEPT_TIMEOUT)
        }
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        if let delegate = self.uiDelegate {
            delegate.connectionManager(ConnectionManager.shared, didReceive: Invite(origin: peerID, handler: invitationHandler))
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        for peer in self.discovered {
            if peerID == peer.id {
                return
            }
        }
        
        let peer = Peer(imageURL: nil, id: peerID)
        if let advertiseInfo = info {
            if let urlString = advertiseInfo["peerImageURL"] {
                if let url = URL(string: urlString) {
                    peer.imageURL = url
                }
            }
        }
        
        self.discovered.append(peer)
        
        if let delegate = self.uiDelegate {
            delegate.connectionManager(ConnectionManager.shared, foundPeer: peerID, withDiscoveryInfo: info)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        for (idx, peer) in self.discovered.enumerated() {
            if peer.id == peerID {
                self.discovered.remove(at: idx)
                if let delegate = self.uiDelegate {
                    delegate.connectionManager(ConnectionManager.shared, lostPeer: peerID)
                }
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Browser error : \(error.localizedDescription)")
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        print("Session : \(session)")
        print("Peer : \(peerID)")
        print("State : \(state.rawValue)")
        
        let userInfo = ["peerID": peerID, "state": state.rawValue] as [String : Any]
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MPC_DidChangeNotification"), object: nil, userInfo: userInfo)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let userInfo = ["peerID": peerID, "data": data] as [String : Any]
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MPC_DidReceiveDataNotification"), object: nil, userInfo: userInfo)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }

}
