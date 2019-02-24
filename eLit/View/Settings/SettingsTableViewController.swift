//
//  SettingsTableViewController.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 18/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import GoogleSignIn


class SettingsTableViewController: BlurredBackgroundTableViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    let accountNib = "AccountTableViewCell"

    var userSettings : UserSettings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareForSignIn()
        self.tableView.register(UINib.init(nibName: accountNib, bundle: nil), forCellReuseIdentifier: accountNib)
        
        self.setBackgroundImage(UIImage(named: "settings_bg.png"), withColor: .orange)
        
        self.userSettings = Preferences.shared.userSettings()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        default:
            return self.userSettings.switches.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            //Header Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: accountNib, for: indexPath) as! AccountTableViewCell
            
            // Getting Google ID shared instance
            guard let gid = GIDSignIn.sharedInstance() else {
                print("CANT GET SHARED GID INSTANCE")
                return cell
                
            }
            
            // Check if the user is logged in
            guard gid.hasAuthInKeychain() else {
                cell.nameLabel.text = "Login with Google"
                cell.emailLabel.text = ""
                cell.profileImageView.image = UIImage(named: "GoogleIcon")
                cell.loginIndicator.stopAnimating()
                return cell
            }
            
            // If the user is logged in there will be a user saved in the db
            // otherwise there is an error
            guard let user = Model.shared.user else {
                cell.nameLabel.text = "ERROR"
                return cell
            }
            
            // Filling up the table cell with user information and getting the image
            cell.nameLabel.text = (user.name ?? "") + " " + (user.familyName ?? "")
            cell.emailLabel.text = user.email ?? ""
            cell.profileImageView.roundImage(with: 1, ofColor: .darkGray)

            user.setImage(completion: { image in
                guard let im = image else {
                    cell.profileImageView.image = UIImage(named: "user")
                    return
                }
                cell.profileImageView.image = im
            })

            return cell
        
        default:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "onOffSettingCell") {
                
                
                let text = self.userSettings.switches[indexPath.row].text
                let val = self.userSettings.switches[indexPath.row].value
                
                self.prepareOnOffCell(cell, at: indexPath.row, text: text, value: val)
                
                return cell
                
            }
            else {
                
                return UITableViewCell()
                
            }
        }
    }
    
    
    // MARK: Google Sing in
    func prepareForSignIn() {
        GIDSignIn.sharedInstance()?.clientID = Preferences.shared.coreSettings.gid
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
        
        
        let cell = tableView.cellForRow(at: IndexPath(indexes: [0, 0])) as! AccountTableViewCell
        cell.profileImageView.image = nil
        cell.loginIndicator.startAnimating()
        
        if let oldUser = Model.shared.user {
            oldUser.updateUserData(data: user)
        } else {
            Model.shared.user = User(data : user)
        }
        
        DataBaseManager.shared.signInUser(user: Model.shared.user!, completion: { response in
            if (response["status"] as? String ?? "error") == "error" {
                // TODO: uncomment the following line in deployment
                GIDSignIn.sharedInstance()?.signOut()
                let alert = UIAlertController(title: "Error", message: "An error occurred trying to sign in, please try again later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                self.present(alert, animated: true)
                print("ERROR saving the user in the remote DB")
            } else {
                Model.shared.savePersistentModel()
            }
            self.onLoginEnd()
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            if (GIDSignIn.sharedInstance()?.hasAuthInKeychain() ?? false) == false {
                GIDSignIn.sharedInstance()?.signIn()
                //TODO: manage sign in data
            } else {
                performSegue(withIdentifier: Navigation.toUserProfileVC.rawValue, sender: self)
            }
            
        default:
            return
        }
 
    }
    
    func onLoginEnd() {
        let cell = self.tableView.cellForRow(at: IndexPath(indexes: [0, 0])) as! AccountTableViewCell
        cell.loginIndicator.stopAnimating()
        self.tableView.reloadRows(at: [IndexPath(indexes: [0, 0])], with: UITableView.RowAnimation.automatic)
    }
    
    
    @objc func didToggleSwitch(sender: SettingsSwitch) {
        
        // Toggle
        Preferences.shared.toggleUserSwitch(at: sender.reference)
        
    }

    
    func prepareOnOffCell(_ cell : UITableViewCell, at index : Int, text : String, value : Bool) {
        
        let label = cell.contentView.viewWithTag(1) as! UILabel
        let toggle = cell.contentView.viewWithTag(2) as! SettingsSwitch
        
        toggle.reference = index
        toggle.addTarget(self, action: #selector(didToggleSwitch(sender:)), for: .valueChanged)
        
        label.text = text
        toggle.isOn = value
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
            case Navigation.toUserProfileVC.rawValue:
                let profileVC = segue.destination as! ProfileTableViewController
                profileVC.callerVC = self
            default:
                return
        }
        
    }
    

}
