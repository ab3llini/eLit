//
//  ProfileTableViewController.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 22/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import GoogleSignIn

class ProfileTableViewController: UITableViewController {
    
    let profileHeaderSectionHeight : CGFloat = 500.0
    let profileCellNib = "ProfileTableViewCell"
    let headerSectionNib = "ProfileHeaderView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: profileCellNib, bundle: nil), forCellReuseIdentifier: profileCellNib)
        
        let headerNib = UINib.init(nibName: headerSectionNib, bundle: nil)
        self.tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: headerSectionNib)
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
        return 100
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: profileCellNib, for: indexPath) as! ProfileTableViewCell
            cell.profileLabel.textColor = UIColor.red
            cell.profileLabel.text = "Log Out"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: profileCellNib, for: indexPath) as! ProfileTableViewCell
            cell.profileLabel.textColor = .black
            cell.profileLabel.text = "Review test"
            return cell
        default:
            return UITableViewCell()
        }
     }
 
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        switch section {
        case 0:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerSectionNib) as! ProfileHeaderView
            Model.shared.user?.setImage(completion: { image in
                headerView.profileImageView.image = image
            })
            let user = Model.shared.user
            let name = user?.name ?? ""
            let fName = user?.familyName ?? ""
            
            headerView.nameLabel.text = name + " " + fName
            headerView.emailLabel.text = user?.email ?? " "
        
            headerView.profileImageView.roundImage(with: 1, ofColor: .darkGray)
            
            return headerView
            
        default:
            return UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 200.0
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ProfileTableViewCell else {
            return
        }
        switch cell.profileLabel.text {
        case "Log Out":
            GIDSignIn.sharedInstance()?.signOut()
            navigationController?.popViewController(animated: true)
        default:
            return
        }
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            let name = Model.shared.user?.name ?? ""
//            let famName = Model.shared.user?.familyName ?? ""
//            return name + " " + famName
//        default:
//            return nil
//        }
//    }
    
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
