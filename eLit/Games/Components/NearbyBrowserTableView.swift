//
//  NearbyBrowserTableView.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 14/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import MultipeerConnectivity



class NearbyBrowserTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private var discovered : [Peer] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        
        self.delegate = self
        self.dataSource = self
        
        // Populate discovered players
        self.discovered = ConnectionManager.shared.discovered
        
    }
    
    func updatePeers() {
        self.discovered = ConnectionManager.shared.discovered
        self.reloadData()
    }
    
    func flush() {
        self.discovered = []
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discovered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peerCell") as! PeerTableViewCell
        
        cell.setPeer(self.discovered[indexPath.row])
        
        return cell
    }
    
   
    
    func getPeer(_ id : MCPeerID) -> Peer? {
        for peer in self.discovered {
            if id == peer.id {
                return peer
            }
        }
        return nil
    }
    
}
