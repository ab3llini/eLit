//
//  LogInViewController.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 17/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import GoogleSignIn

@IBDesignable class LogInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    @IBOutlet weak var LoginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.clientID = "398361482981-in05p8hbkfqrvva0gdfq4hqoh053jrbo.apps.googleusercontent.com"
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        let signInButton = GIDSignInButton(frame: CGRect())
        signInButton.center = view.center
        view.addSubview(signInButton)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onLoginPressed(_ sender: Any) {
        
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print(user.profile.email)
        print(user.profile.name)
        print(user.profile.familyName)
    }
    

}
