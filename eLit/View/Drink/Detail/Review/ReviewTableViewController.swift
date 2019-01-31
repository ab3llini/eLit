//
//  ReviewTableViewController.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 29/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class ReviewTableViewController: BlurredBackgroundTableViewController {
    
    let nibs = ["ReviewTableViewCell", "LoadingTableViewCell"]
    var endReviews = false
    var requestPending = false
    var error = false
    var drink: Drink {
        let d = Drink(name: "lala", image: "Drink1", degree: 1)
        d.id = String(1000)
        return d
    }
    var reviews: [[String: String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for nib in nibs {
            self.tableView.register(UINib.init(nibName: nib, bundle: nil), forCellReuseIdentifier: nib)
        }
        // self.loadNextBatch()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // if reached last row, load next batch
        if indexPath.row == self.reviews.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath) as! LoadingTableViewCell
            cell.spinner.startAnimating()
            return cell
        }
        
        // else show the cell as usual
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        cell.titleLabel.text = String(reviews[indexPath.row]["title"]!) + Model.randomString(length: 10)
        cell.reviewTextLabel.text = Model.randomString(length: Int.random(in: 100...1000))
        return cell
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
            if data["status"] as! String == "error" {
                self.error = true
                return
            }
            let r = data["data"] as! NSArray
            for e in r {
                let i = e as! NSDictionary
                self.reviews.append(["title": i["title"] as! String])
                if (i["is_last"] as! String) == "true" {
                    self.endReviews = true
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.requestPending = false
            }
        }
        
        self.requestPending = true
        
        DataBaseManager.shared.requestReviews(for: self.drink, from: self.reviews.count, completion: callback)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
