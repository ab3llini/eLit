//
//  ReviewTableViewController.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 29/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import Foundation

struct Review {
    
    let author : String
    let rating : Double
    let title : String
    let text : String
    let timestamp : String
}

class ResizingCell {
    var cell : ReviewTableViewCell
    var ip : IndexPath
    init(cell : ReviewTableViewCell,  ip : IndexPath) {
        self.cell = cell
        self.ip = ip
    }
}

class ReviewTableViewController: BlurredBackgroundTableViewController, ReviewTableViewCellDelegate {

    let nibs = ["ReviewTableViewCell", "LoadingTableViewCell"]
    var endReviews = false
    var requestPending = false
    var error = false
    var drink : Drink!
    var reviews: [Review] = []
    var resizingCell : ResizingCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for nib in nibs {
            self.tableView.register(UINib.init(nibName: nib, bundle: nil), forCellReuseIdentifier: nib)
        }
    
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if endReviews {
            return reviews.count
        }
        return reviews.count + 1
    }
    
    func reviewTableViewCell(_ cell: ReviewTableViewCell, didExpand: Bool, with frame: CGRect) {
        if let ip = self.tableView.indexPath(for: cell) {
            self.resizingCell = ResizingCell(cell: cell, ip: ip)
            self.tableView.reloadRows(at: [ip], with: .none)
        }
        self.resizingCell = nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // if reached last row, load next batch
        if indexPath.row == self.reviews.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath) as! LoadingTableViewCell
            if !endReviews {
                cell.spinner.startAnimating()
            } else {
                cell.spinner.stopAnimating()
            }
            return cell
        }
        
        if let resizing = self.resizingCell, resizing.ip == indexPath {
            return resizing.cell
        }
        else {
            // else show the cell as usual
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
            cell.titleLabel.text = reviews[indexPath.row].title
            cell.starsView.rating = reviews[indexPath.row].rating
            cell.reviewTextLabel.text = reviews[indexPath.row].text
            cell.userLabel.text = reviews[indexPath.row].author
            cell.timestampLabel.text = reviews[indexPath.row].timestamp
            cell.delegate = self
            if (!cell.reviewTextLabel.isCollapsed()) {
                let _ = cell.reviewTextLabel.toggleCollapse()
                cell.showMoreButton.setTitle("Show more..", for: .normal)
            }

            return cell
        }
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            if !self.requestPending {
                if !endReviews {
                    loadNextBatch()
                }
            }
        }
    }
    
    
    // MARK: Auxiliar functions
    private func loadNextBatch() {
        let callback: (_ data: [String: Any]) -> Void = { data in
            
            func reload() {
                self.tableView.reloadData()
                self.requestPending = false
            }
            
            if data["status"] as! String == "error" {
                self.error = true
                self.endReviews = true
                reload()
                return
            }
            guard let r = data["data"] as? NSArray else {
                self.endReviews = true
                reload()
                return
            }
            for e in r {
                let i = e as! NSDictionary
                
                
                
                let review = Review(
                    author : i["author"] as! String,
                    rating: i["rating"] as! Double,
                    title: i["title"] as! String,
                    text: i["text"] as! String,
                    timestamp: i["timestamp"] as! String

                )
                
                self.reviews.append(review)
                
                if (i["is_last"] as! Bool) {
                    self.endReviews = true
                }
            }
            
            reload()

        }
        
        self.requestPending = true
        
        DataBaseManager.shared.requestReviews(for: self.drink, from: self.reviews.count, completion: callback)
    }

}
