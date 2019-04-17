//
//  NearbyBrowserTableView.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 14/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol NearbyBrowserTableViewDelegate {
    func browserTableView(_ browserTableView: NearbyBrowserTableView, cell: PeerTableViewCell, didInvite peer: MCPeerID)
}

class NearbyBrowserTableView: UITableView, UITableViewDelegate, UITableViewDataSource, PeerTableViewCellDelegate {
    
    private var discovered : [MCPeerID] = []
    public var browserDelegate : NearbyBrowserTableViewDelegate?
    
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
    }
    
    func update(peers : [MCPeerID]) {
        self.discovered = peers
        self.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discovered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peerCell") as! PeerTableViewCell
        
        cell.setPeer(self.discovered[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func peerCell(_ cell: PeerTableViewCell, didInvite peer: MCPeerID) {
        if let _ = self.browserDelegate {
            self.browserDelegate!.browserTableView(self, cell: cell, didInvite: peer)
        }
    }
    
}
