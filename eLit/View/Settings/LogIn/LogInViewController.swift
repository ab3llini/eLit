//
//  LogInViewController.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 20/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import GoogleSignIn

class LogInViewController: UIViewController {
    @IBOutlet weak var loggingIn: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let gid = GIDSignIn.sharedInstance() else { return }
        let userIsLoggedIn = gid.hasAuthInKeychain()
        if userIsLoggedIn {
            navigationController?.popViewController(animated: true)
        }
    }


}
