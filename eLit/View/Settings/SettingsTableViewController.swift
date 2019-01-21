//
//  SettingsTableViewController.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 18/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import GoogleSignIn

class SettingsTableViewController: UITableViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    let accountNib = "AccountTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareForSignIn()
//        GIDSignIn.sharedInstance()?.signOut()
        self.tableView.register(UINib.init(nibName: accountNib, bundle: nil), forCellReuseIdentifier: accountNib)
        
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
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.row == 0) {
            
            //Header
            let cell = tableView.dequeueReusableCell(withIdentifier: accountNib, for: indexPath) as! AccountTableViewCell
            
            guard let gid = GIDSignIn.sharedInstance() else {
                print("CANT GET SHARED GID INSTANCE")
                cell.nameLabel.text = "ERROR"
                return cell
                
            }
            guard gid.hasAuthInKeychain() else {
                cell.profileImageView.image = UIImage(named: "user")
                cell.nameLabel.text = "Login with Google"
                cell.emailLabel.text = ""
                return cell
            }
            
            guard let user = Model.shared.user else {
                cell.nameLabel.text = "ERROR"
                return cell
            }
            
            cell.nameLabel.text = user.name ?? ""
            cell.emailLabel.text = user.email ?? ""
            if (user.image != nil) {
                cell.profileImageView.image = user.image!
            } else {
                cell.profileImageView.image = UIImage(named: "user")
            }
            return cell
        }
        
        // Other cells
        return UITableViewCell()
    }
    
    
    // Changes the table raws if needed
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadRows(at: [IndexPath(indexes: [0, 0])], with: UITableView.RowAnimation.automatic)
    }
    
    // MARK: Google Sing in
    func prepareForSignIn() {
        GIDSignIn.sharedInstance()?.clientID = "398361482981-in05p8hbkfqrvva0gdfq4hqoh053jrbo.apps.googleusercontent.com"
        if GIDSignIn.sharedInstance()?.uiDelegate == nil {
            GIDSignIn.sharedInstance()?.uiDelegate = self
        }
        if GIDSignIn.sharedInstance()?.delegate == nil {
            GIDSignIn.sharedInstance()?.delegate = self
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard (user != nil) else { return }
        
        if let occuredError = error {
            print("Error during signIn = \(occuredError.localizedDescription)")
        }
        
        if let oldUser = Model.shared.user {
            oldUser.updateUserData(data: user)
        } else {
            Model.shared.user = User(data : user)
        }
        
        print(CoreDataObject.getContext().hasChanges)
        Model.shared.savePersistentModel()
        print(CoreDataObject.getContext().hasChanges)
        
        print("---------------------------")
        print(Model.shared.entityManager.fetchAll(type: User.self) ?? "nil")
        
        //TODO: Manage sigin in
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if (GIDSignIn.sharedInstance()?.hasAuthInKeychain() ?? false) == false {
                performSegue(withIdentifier: Navigation.toLogInVC.rawValue, sender: self)
            }
        }
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
