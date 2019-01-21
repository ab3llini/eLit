//
//  CoreDataObject.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 29/12/2018.
//  Copyright © 2018 Alberto Mario Bellini. All rights reserved.
//

import UIKit
import CoreData


class CoreDataObject: NSManagedObject {
    
    
    //MARK: Initializers
    convenience init () {
        self.init(context: CoreDataObject.getContext())
        
    }
    
    convenience init(dict: [String: Any]) {
        self.init(context: CoreDataObject.getContext())
        self.id = dict["id"] as? String
        self.fingerprint = dict["fingerprint"] as? String
    }

    public class func getContext() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
}
