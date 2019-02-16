//
//  DrinkCategory.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 14/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import CoreData

@objc(DrinkCategory)
class DrinkCategory: DrinkObjectWithImage {
    //MARK: Initializers
    
    convenience init(dict: [String: Any]) {
        
        // TODO CHeck existence
        
        self.init()
        self.id = dict["id"] as? String ?? ""
        self.fingerprint = dict["fingerprint"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.imageURLString = dict["image"] as? String ?? ""
    }
    
    override func update(with data: [String : Any], savePersistent: Bool) {
        self.name = data["name"] as? String ?? ""
        self.imageURLString = data["image"] as? String ?? ""
        self.image = UIImage()
        self.imageData = nil
        super.update(with: data, savePersistent: savePersistent)
    }

}
