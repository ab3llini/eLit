//
//  MPCHandler.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 10/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MPCHandler: NSObject, MCSessionDelegate {
    
    public static let shared = MPCHandler()
    var peerID: MCPeerID!
    var session: MCSession!
    var browser: MCBrowserViewController!
    var advertiser: MCAdvertiserAssistant? = nil
    
    func setupPeer(with displayName: String) {
        self.peerID = MCPeerID(displayName: displayName)
    }
    
    func setupSession() {
        self.session = MCSession(peer: self.peerID)
        session.delegate = self
    }
    
    func setupBrowser() {
        self.browser = MCBrowserViewController(serviceType: "game", session: self.session)
    }
    
    func advertiseSelf(advertise: Bool) {
        if advertise {
            self.advertiser = MCAdvertiserAssistant(serviceType: "game", discoveryInfo: nil, session: self.session)
            self.advertiser?.start()
        } else {
            self.advertiser?.stop()
            advertiser = nil
        }
    }
    
    
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
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
