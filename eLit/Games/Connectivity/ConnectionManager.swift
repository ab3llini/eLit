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

struct Invite {
    var origin : MCPeerID
    var handler : (Bool) -> Void
}


protocol ConnectionManagerUIDelegate {
    func connectionManager(didReceive invite : Invite)
    func connectionManager(foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?)
    func connectionManager(lostPeer peerID: MCPeerID)
    func connectionManager(peer : MCPeerID, didRefuseInvite : Invite)
    func connectionManager(peer : MCPeerID, didAcceptInvite : Invite)
}

protocol ConnectionManagerSessionDelegate : MCSessionDelegate {
    
}

class ConnectionManager: NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    
    public static let shared = ConnectionManager()
    
    public private(set) var session : MCSession!
    
    public private(set) var peerID : MCPeerID!
    
    private var browser : MCNearbyServiceBrowser!
    private var advertiser : MCNearbyServiceAdvertiser!
    
    public var discovered : [MCPeerID] = []
    
    private var pendingInvites : [MCPeerID] = []
    private var receivedInvites : [MCPeerID] = []

    private var isAdvertising = false
    private var isBrowsing = false
    
    private let SERVICE_TYPE : String = "game"
    public let ACCEPT_TIMEOUT : TimeInterval = 30.0
    
    // Delegates
    public var uiDelegate : ConnectionManagerUIDelegate?
    
    override init() {
        super.init()
        self.SBAInit()
    }
    
    private func SBAInit() {
        
        var peerName = UIDevice.current.name
        var info : [String : String]?
        if self.isLoggedIn() {
            peerName = Model.shared.user!.name!
            info = ["peerImageURL" : Model.shared.user!.imageURLString] as? [String : String]
        }
        self.peerID = MCPeerID(displayName: peerName)
        self.session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
        self.advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: info, serviceType: SERVICE_TYPE)
        self.browser = MCNearbyServiceBrowser(peer: peerID, serviceType: SERVICE_TYPE)
        
        self.session.delegate = self
        self.browser.delegate = self
        self.advertiser.delegate = self
    }
    
    func updatePeerInfo() {
        
        if self.isBrowsing {
            self.browser.stopBrowsingForPeers()
            self.isBrowsing = false
        }
        if self.isAdvertising {
            self.advertiser.stopAdvertisingPeer()
            self.isAdvertising = false
        }
        self.session.disconnect()
        self.SBAInit()
    }
    
    func startBrowsing() {
        if !self.isBrowsing {
            self.browser.startBrowsingForPeers()
            self.isBrowsing = true
        }
    }
    
    func startAdvertising() {
        if !self.isAdvertising {
            self.advertiser.startAdvertisingPeer()
            self.isAdvertising = true
        }
    }
    
    func stopBrowsing() {
        if self.isBrowsing {
            self.browser.stopBrowsingForPeers()
            self.isBrowsing = false
        }
    }
    
    func stopAdvertising() {
        if self.isAdvertising {
            self.advertiser.stopAdvertisingPeer()
            self.isAdvertising = false
        }
    }
    
    func invite(_ peerID : MCPeerID) {
        self.browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: ACCEPT_TIMEOUT)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        self.uiDelegate?.connectionManager(didReceive: Invite(origin: peerID, handler: { (selection) in
            invitationHandler(selection, self.session)
        }))
        
        print("Received invite from \(peerID.displayName)")
        
        
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("Can't advertise")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found new peer: \(peerID)")
        self.discovered.append(peerID)
        self.uiDelegate?.connectionManager(foundPeer: peerID, withDiscoveryInfo: info)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        print("Lost peer : \(peerID.displayName)")
        if let discovered = self.discovered.index(of: peerID) {
            self.discovered.remove(at: discovered)
            self.uiDelegate?.connectionManager(lostPeer: peerID)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Can't start browsing")
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("\(peerID.displayName) : Changed state to \(state.rawValue)")
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("Received data from \(peerID.displayName)")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("Received stream from \(peerID.displayName)")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("Start receiving resource from \(peerID.displayName)")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("Stop receiving resource from \(peerID.displayName)")
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        print("Received certificate from \(peerID.displayName)")

    }
    
    public func isLoggedIn() -> Bool {
        if let gid = GIDSignIn.sharedInstance() {
            if gid.hasAuthInKeychain() {
                return true
            }
        }
        return false
    }
}
