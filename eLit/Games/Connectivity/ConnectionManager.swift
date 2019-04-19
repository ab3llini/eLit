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



struct IncomingInvite {
    var origin : MCPeerID
    var handler : (Bool, MCSession) -> Void
    
    init(origin : MCPeerID, handler : @escaping (Bool, MCSession) -> Void) {
        self.origin = origin
        self.handler = handler
    }
}

struct UIInvite  {
    var origin : MCPeerID
    var handler : (Bool) -> Void
    
    init(origin : MCPeerID, handler : @escaping (Bool) -> Void, imageUrl : String? = nil) {
        self.origin = origin
        self.handler = handler
    }
}

struct DiscoveredPeer {
    var peerID : MCPeerID
    var imageUrl : String?
    var peerName : String?
    
    init(_ peerID : MCPeerID, imageUrl : String? = nil, name : String? = nil) {
        self.peerID = peerID
        self.imageUrl = imageUrl
        self.peerName = name
    }
}

struct OutgoingInvite {
    var destination : MCPeerID
    var runningTime : TimeInterval
    
    init(destination : MCPeerID, runningTime : TimeInterval) {
        self.destination = destination
        self.runningTime = runningTime
    }
}

enum OperationMode {
    case host, client
}


typealias HighScoreEntry = (Int)

extension Sequence where Iterator.Element == OutgoingInvite {
    func contains(_ peerID : MCPeerID) -> Bool {
        for e in self {
            if e.destination == peerID {
                return true
            }
        }
        return false
    }
    func get(_ peerID : MCPeerID) -> OutgoingInvite? {
        for e in self {
            if e.destination == peerID {
                return e
            }
        }
        return nil
    }
    func index (of peerID : MCPeerID) -> Int? {
        for (i, e) in self.enumerated() {
            if e.destination == peerID {
                return i
            }
        }
        return nil
    }
}

extension Sequence where Iterator.Element == DiscoveredPeer {
    func contains(_ peerID : MCPeerID) -> Bool {
        for e in self {
            if e.peerID == peerID {
                return true
            }
        }
        return false
    }
    func get(_ peerID : MCPeerID) -> DiscoveredPeer? {
        for e in self {
            if e.peerID == peerID {
                return e
            }
        }
        return nil
    }
    func index (of peerID : MCPeerID) -> Int? {
        for (i, e) in self.enumerated() {
            if e.peerID == peerID {
                return i
            }
        }
        return nil
    }
}

protocol ConnectionManagerDelegate {
    
    func connectionManager(didReceive invite : UIInvite)
    func connectionManager(foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?)
    func connectionManager(lostPeer peerID: MCPeerID)
    func connectionManager(peer: MCPeerID, didAcceptInvite: Bool)
    func connectionManager(peer: MCPeerID, connectedTo session : MCSession, with operationMode: OperationMode)
}

protocol ConnectionManagerGameEngineDelegate {
    func connectionManager(didReceive requestType: MPCRequestType) -> Any?
}



class ConnectionManager: NSObject {
    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    private let connectionManagerType = "game"
    
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceBrowser : MCNearbyServiceBrowser
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    public private(set) var discovered : [DiscoveredPeer] = []
    
    private var outgoingInvites : [OutgoingInvite] = []
    private var incomingInvite : IncomingInvite?
    private var completionForQuestion: ((_: Question?) -> Void)? = nil
    private var completionForAnswer: ((_: String?) -> Void)? = nil
    
    private let timeStarted = Date()
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    public var delegate : ConnectionManagerDelegate?
    public var gameEngineDelegate: ConnectionManagerGameEngineDelegate?
    public static let shared = ConnectionManager()
    public private(set) var operationMode: OperationMode?
    
    private var started : Bool = false
    
    override init() {
        
        var info : [String : String]? = nil
        
        if let gid = GIDSignIn.sharedInstance(), gid.hasAuthInKeychain() {
            info = [
                "peerImageURL" : Model.shared.user!.imageURLString,
                "peerName" : Model.shared.user!.name
                ] as? [String : String]
        }
        
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: info, serviceType: connectionManagerType)
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
        if !self.started {
            self.serviceBrowser.startBrowsingForPeers()
            self.serviceAdvertiser.startAdvertisingPeer()
            self.started = true
        }
    }
    func stop() {
        if self.started {
            self.serviceBrowser.stopBrowsingForPeers()
            self.serviceAdvertiser.stopAdvertisingPeer()
            self.started = false
        }
    }
    
    func invite(_ peerID : MCPeerID) {
        
        if !self.outgoingInvites.contains(peerID) {
            
            // Leader election
            var runningTime = self.timeStarted.timeIntervalSinceNow // 10, 50
            let context : Data = Data(bytes: &runningTime, count: MemoryLayout.size(ofValue: runningTime))
            
            let newOutgoingInvite = OutgoingInvite(destination: peerID, runningTime: runningTime)

            self.outgoingInvites.append(newOutgoingInvite)
            self.serviceBrowser.invitePeer(peerID, to: self.session, withContext: context, timeout: 60)
        }
    }
}

extension ConnectionManager : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
//        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
//        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
    
        if self.outgoingInvites.contains(peerID) {
            // Resolve connection races
            var remoteRunningTime : TimeInterval = TimeInterval()
            if let _ = context {
                (context! as NSData).getBytes(&remoteRunningTime, length: MemoryLayout.size(ofValue: remoteRunningTime))
                let invite = self.outgoingInvites.get(peerID)!
                if invite.runningTime < remoteRunningTime {
                    invitationHandler(false, self.session)
                }
            }
            else {
                invitationHandler(false, self.session)
            }
        }
        
        if (self.incomingInvite != nil) || self.session.connectedPeers.count > 1 {
            // Refuse the invite
            invitationHandler(false, self.session)
        }
        else {
            if let _ = self.delegate {
                self.incomingInvite = IncomingInvite(origin: peerID, handler: invitationHandler)
                
                DispatchQueue.main.async {
                    self.delegate!.connectionManager(didReceive: UIInvite(origin: peerID, handler: { (answer) in
                        if !answer {
                            self.incomingInvite = nil
                        }
                        invitationHandler(answer, self.session)
                    }))
                }
            }
        }
    }
}

extension ConnectionManager : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
//        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
//        NSLog("%@", "foundPeer: \(peerID)")
        
        let newPeer : DiscoveredPeer!
        
        if let _ = info, let imageUrl = info!["peerImageURL"], let name = info!["peerName"] {
            newPeer = DiscoveredPeer(peerID, imageUrl: imageUrl, name: name)
        } else {
            newPeer = DiscoveredPeer(peerID)
        }
        
        if !self.discovered.contains(peerID) {
            self.discovered.append(newPeer)
        }
        
        if let _ = self.delegate {
            DispatchQueue.main.async {
                self.delegate!.connectionManager(foundPeer: peerID, withDiscoveryInfo: info)
            }
        }
        //browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
//        NSLog("%@", "lostPeer: \(peerID)")
        
        if let index = self.discovered.index(of: peerID) {
            
            self.discovered.remove(at: index)
            
            if let _ = self.delegate {
                DispatchQueue.main.async {
                    self.delegate!.connectionManager(lostPeer: peerID)
                }
            }
        }
    }
}


extension ConnectionManager : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
//        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
        
        switch state {
        case .notConnected:
            if self.incomingInvite?.origin == peerID {
                // Local peer refused invite from remote peer
                self.incomingInvite = nil
                print("Local peer refused invite from remote peer")
                
            }
            else {
                if self.outgoingInvites.contains(peerID) {
                    // Remote peer refused local invite
                    print("Remote peer refused local invite")
                    self.outgoingInvites.remove(at: self.outgoingInvites.index(of: peerID)!)
                    
                    if let _ = self.delegate {
                        DispatchQueue.main.async {
                            self.delegate!.connectionManager(peer: peerID, didAcceptInvite: false)
                        }
                    }
                }
                else {
                    // Remote peer disconnected from local session!
                    print("Remote peer disconnected from local session!")
                }
            }
        case .connecting:
            if self.incomingInvite?.origin == peerID {
                if self.session.connectedPeers.count > 1 {
                    // We accepted an invitation, but we will end up in a session with more than two players!
                    // We need to disconnect from it
                    print("We accepted an invitation, but we will end up in a session with more than two players!")
                    self.session.disconnect()
                    self.incomingInvite = nil

                }
                else {
                    // Local peer accepted invite from remote peer, connecting to his session
                    print("Local peer accepted invite from remote peer, connecting to his session")
                }
            }
            else {
                if self.outgoingInvites.contains(peerID) {
                    // Remote peer accepted local invite, he is connecting to the local session
                    // Let's check if we our session is full
                    print("Remote peer accepted local invite, he is connecting to the local session")
                    if let _ = self.delegate {
                        DispatchQueue.main.async {
                            self.delegate!.connectionManager(peer: peerID, didAcceptInvite: true)
                        }
                    }
                }
            }
        case .connected:
            
            print("CONNECTED INFO: SELF = \(self.session), DELEGATE = \(session)")

            if self.incomingInvite?.origin == peerID {
                // Local peer accepted invite from remote peer and is now connected to his session
                
                if self.session.connectedPeers.count > 1 {
                    // We accepted an invitation, but we ended up in a session with more than two players!
                    // We need to disconnect from it
                    print("We need to disconnect from remote session because it is full")

                    self.session.disconnect()
                    self.incomingInvite = nil

                }
                else {
                    // We can start playing with the remote peer
                    // We might want to stop advertising and browsing here and transition to the game
                    // In any case, we need to prevent other peers from inviting us
                    print("We can start playing with the remote peer")
                    self.incomingInvite = nil
                    if let _ = self.delegate {
                        DispatchQueue.main.async {
                            
                            self.operationMode = .client
                            self.delegate!.connectionManager(peer: self.myPeerId, connectedTo: self.session, with: .client)
                        }
                    }
                }
            }
            else if self.outgoingInvites.contains(peerID) {
                // Remote peer accepted local invite and he is now connected to the local session
                // We might want to stop advertising and browsing here and transition to the game
                // In any case, we need to prevent other peers from inviting us
                self.outgoingInvites.remove(at: self.outgoingInvites.index(of: peerID)!)
                if let _ = self.delegate {
                    DispatchQueue.main.async {
                        
                        self.operationMode = .host
                        self.delegate!.connectionManager(peer: self.myPeerId, connectedTo: self.session, with: .host)
                    }
                }
            }
        default:
            return
        }
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            let dataDict = self.fromJson(data)
            let requestType = dataDict["request"]
            print("********* Received data for request \(String(describing: requestType))")
            switch requestType {
            
            case MPCRequestType.question.rawValue:
                guard let completion = self.completionForQuestion else {
                    return
                }
                let question = dataDict
                let q = Question(from: question)
                completion(q)
            
            case MPCRequestType.requestQuestion.rawValue:
                guard let q = self.gameEngineDelegate?.connectionManager(didReceive: .requestQuestion) as? Question else {
                    return
                }
                
                var dataDict = q.toDict()
                dataDict["request"] = MPCRequestType.question.rawValue
                self.sendData(dataDict)
            default:
                return
            }
        }
        
//        NSLog("%@", "didReceiveData: \(data)")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
//        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
//        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
//        NSLog("%@", "didFinishReceivingResourceWithName")
    }
}

enum MPCRequestType: String {
    case requestQuestion = "RequestQuestion"
    case question = "Question"
    case requestAnswer = "RequestAnswer"
    case answer = "Answer"
    
}

extension ConnectionManager {
    func requestQuestion(then completion: @escaping (_ question: Question?) -> Void) {
        self.completionForQuestion = completion
        let data = ["request": MPCRequestType.requestQuestion.rawValue] as [String: String]
        self.sendData(data)
    }
    
    func askForAnswer(then completion: (_ answer: String?) -> Void) {
        //        TODO:
    }
    
    private func sendData(_ dataDict: [String: String]) {
        print("******** Sending \(dataDict["request"])")
        let dataToSend = toJson(dataDict)
        do {
            try self.session.send(dataToSend!, toPeers: self.session.connectedPeers, with: .reliable)
        } catch {
            print("Error sending data")
        }
    }
    
    private func toJson(_ data: [String: String]) -> Data? {
        do {
            let json = try JSONSerialization.data(withJSONObject: data)
            return json
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func fromJson(_ data: Data) -> [String: String] {
        guard let stringData = String(data: data, encoding: .utf8) else { return [:] }
        guard let jsonData = stringData.data(using: .utf8) else { return [:] }
        
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData)
            let dictData = json as? [String: String] ?? [:]
            return dictData
        } catch {
            return [:]
        }
    }
    
}
