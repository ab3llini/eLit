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

struct Invite {
    var origin : MCPeerID
    var handler : (Bool) -> Void
}

enum OperationMode {
    case host, client
}

protocol ConnectionManagerDelegate {
    
    func connectionManager(didReceive invite : Invite)
    func connectionManager(foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?)
    func connectionManager(lostPeer peerID: MCPeerID)
    func connectionManager(peer: MCPeerID, didAcceptInvite: Bool)
    func connectionManager(peer: MCPeerID, connectedTo session : MCSession, with operationMode: OperationMode)
    
}

class ConnectionManager: NSObject {
    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    private let connectionManagerType = "game"
    
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceBrowser : MCNearbyServiceBrowser
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    public private(set) var discovered : [MCPeerID] = []
    
    private var pendingInvites : [MCPeerID] = []
    private var receivedInvite : MCPeerID?
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    public var delegate : ConnectionManagerDelegate?
    public static let shared = ConnectionManager()
    
    override init() {
        
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: connectionManagerType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: connectionManagerType)
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        self.serviceBrowser.delegate = self
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    func start() {
        
        self.serviceBrowser.startBrowsingForPeers()
        self.serviceAdvertiser.startAdvertisingPeer()
        
    }
    
    func invite(_ peerID : MCPeerID) {
        if !self.pendingInvites.contains(peerID) {
            self.pendingInvites.append(peerID)
            self.serviceBrowser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 60)
        }
    }
}



extension ConnectionManager : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        
        if (self.receivedInvite != nil) || self.session.connectedPeers.count > 1 {
            // Refuse the invite
            invitationHandler(false, self.session)
        }
        else {
            if let _ = self.delegate {
                self.receivedInvite = peerID
                self.delegate!.connectionManager(didReceive: Invite(origin: peerID, handler: { (answer) in
                    invitationHandler(answer, self.session)
                }))
            }
        }
    }
}

extension ConnectionManager : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        
        self.discovered.append(peerID)
        
        if let _ = self.delegate {
            self.delegate!.connectionManager(foundPeer: peerID, withDiscoveryInfo: info)
        }
        //browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
        
        if let index = self.discovered.index(of: peerID) {
            
            self.discovered.remove(at: index)
            
            if let _ = self.delegate {
                self.delegate!.connectionManager(lostPeer: peerID)
            }
        }
    }
    
}


extension ConnectionManager : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
        
        switch state {
        case .notConnected:
            if self.receivedInvite == peerID {
                // Local peer refused invite from remote peer
                self.receivedInvite = nil
            }
            else {
                if self.pendingInvites.contains(peerID) {
                    // Remote peer refused local invite
                    self.pendingInvites.remove(at: self.pendingInvites.index(of: peerID)!)
                    
                    if let _ = self.delegate {
                        self.delegate!.connectionManager(peer: peerID, didAcceptInvite: false)
                    }
                }
                else {
                    // Remote peer disconnected from local session!
                }
            }
        case .connecting:
            if self.receivedInvite == peerID {
                if self.session.connectedPeers.count > 1 {
                    // We accepted an invitation, but we will end up in a session with more than two players!
                    // We need to disconnect from it
                    self.session.disconnect()
                    self.receivedInvite = nil
                }
                else {
                    // Local peer accepted invite from remote peer, connecting to his session
                }
            }
            else {
                if self.pendingInvites.contains(peerID) {
                    // Remote peer accepted local invite, he is connecting to the local session
                    // Let's check if we our session is full
                    if self.session.connectedPeers.count == 1 {
                        // We can proceed and notify local peer about invite accepted
                        if let _ = self.delegate {
                            self.delegate!.connectionManager(peer: peerID, didAcceptInvite: true)
                        }
                    }
                }
            }
        case .connected:
            if self.receivedInvite == peerID {
                // Local peer accepted invite from remote peer and is now connected to his session
                
                if self.session.connectedPeers.count > 1 {
                    // We accepted an invitation, but we ended up in a session with more than two players!
                    // We need to disconnect from it
                    self.session.disconnect()
                    self.receivedInvite = nil
                }
                else {
                    // We can start playing with the remote peer
                    // We might want to stop advertising and browsing here and transition to the game
                    // In any case, we need to prevent other peers from inviting us
                    self.receivedInvite = nil
                    if let _ = self.delegate {
                        self.delegate!.connectionManager(peer: self.myPeerId, connectedTo: self.session, with: .client)
                    }
                }
            }
            else {
                if self.pendingInvites.contains(peerID) {
                    // Remote peer acceptied local invite and he is now connected to the local session
                    // We might want to stop advertising and browsing here and transition to the game
                    // In any case, we need to prevent other peers from inviting us
                    self.pendingInvites.remove(at: self.pendingInvites.index(of: peerID)!)
                    if let _ = self.delegate {
                        self.delegate!.connectionManager(peer: self.myPeerId, connectedTo: self.session, with: .host)
                    }
                }
            }
        default:
            return
        }
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
}

