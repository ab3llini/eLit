//
//  DrinkObject.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 22/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import CoreData

@objc(DrinkObject)
class DrinkObject: CoreDataObject {
    
    convenience init(dict: [String: Any]) {
        self.init()
        self.id = dict["id"] as? String
        self.fingerprint = dict["fingerprint"] as? String
    }
    
    public func update(with data: [String: Any], savePersistent: Bool = false) {
        self.fingerprint = data["fingerprint"] as? String
        if savePersistent {
            Model.shared.savePersistentModel()
        }
    }

}
