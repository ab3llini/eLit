//
//  LogInView.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 20/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import GoogleSignIn

class LogInView: UIView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        GIDSignIn.sharedInstance()?.signIn()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
