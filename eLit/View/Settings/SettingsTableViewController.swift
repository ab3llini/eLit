//
//  SettingsTableViewController.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 18/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import GoogleSignIn



class SettingsTableViewController: BlurredBackgroundTableViewController, GIDSignInUIDelegate, GIDSignInDelegate, LogoutDelegate {
    
    let accountNib = "AccountTableViewCell"
    var userSettings : UserSettings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareForSignIn()
        self.tableView.register(UINib.init(nibName: accountNib, bundle: nil), forCellReuseIdentifier: accountNib)
        
        self.setBackgroundImage(UIImage(named: "settings_bg.png"), withColor: .orange)
        
        self.userSettings = Preferences.shared.userSettings
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let gid = GIDSignIn.sharedInstance() else { return 2 }
        
        if gid.hasAuthInKeychain() {
            return 3 // account for logout cell if we are logged
        }
        else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 2:
            return 1
        default:
            return (UIScreen.main.traitCollection.horizontalSizeClass == .compact) ? self.userSettings.switches.count : self.userSettings.switches.count - 1
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

            user.setImage(completion: { image in
                guard let im = image else {
                    cell.profileImageView.image = UIImage(named: "user")
                    return
                }
                cell.profileImageView.image = im
            })

            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "logoutSettingCell") as! LogoutTableViewCell
            cell.delegate = self
            return cell

        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "onOffSettingCell") as! SettingsTableViewCell
                
            cell.settingDescription.text = self.userSettings.switches[indexPath.row].text
            cell.settingStatus.reference = indexPath.row
            cell.settingStatus.addTarget(self, action: #selector(didToggleSwitch(sender:)), for: .valueChanged)
            cell.settingStatus.isOn = self.userSettings.switches[indexPath.row].value
            return cell
        }
    }
    
    func didLogout() {
        // HANDLE LOGOUT HERE
        let cell = tableView.cellForRow(at: IndexPath(indexes: [0, 0])) as! AccountTableViewCell
        cell.signInContainer.isHidden = false
        cell.emailLabel.text = ""
        cell.nameLabel.text = ""
        cell.profileImageView.image = UIImage(named: "user")
        self.tableView.reloadData()
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
        cell.signInContainer.isHidden = true
        
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
            }
            
        default:
            return
        }
 
    }
    
    func onLoginEnd() {
        let cell = self.tableView.cellForRow(at: IndexPath(indexes: [0, 0])) as! AccountTableViewCell
        cell.loginIndicator.stopAnimating()
        self.tableView.reloadData()
    }
    
    
    @objc func didToggleSwitch(sender: SettingsSwitch) {
        
        // Toggle
        Preferences.shared.toggleUserSwitch(at: sender.reference)
        
        if (sender.reference == UserSettingsSwitchType.darkMode.rawValue) {
            
            DarkModeManager.shared.triggerNotificationFor(state: sender.isOn)
            
        }
        
    }


}
