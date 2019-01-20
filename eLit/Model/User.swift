//
//  User.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 19/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class User: NSObject {
    var email: String?
    var name: String?
    public static let shared = User()
    
    private override init() {
        super.init()
    }

}
