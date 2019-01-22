//
//  EntityManager.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 29/12/2018.
//  Copyright © 2018 Alberto Mario Bellini. All rights reserved.
//

import UIKit
import CoreData

class EntityManager: NSObject {
    
    //MARK: attributes
    public static let shared = EntityManager()
    
    //MARK: initializers
    private override init() {
        
    }

    //MARK: public methods
    public func fetchAll <T : CoreDataObject> (type : T.Type) -> [T]? {
        let request : NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        do {
            return try EntityManager.shared.getContext().fetch(request) as? [T]
        }
        catch {
            print("ERROR in fetch all")
            return nil
        }
    }
    
    public func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

}
