//
//  Test.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 21/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import CoreData

@objc(TestEntity)
class TestEntity: NSManagedObject {
    
    convenience init(name: String) {
        self.init(context: CoreDataObject.getContext())
        self.name = name
    }

}
