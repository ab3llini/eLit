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
    private static let instance = EntityManager()
    
    //MARK: initializers
    private override init() {
        
    }
    
    //MARK: Accessors
    class func getInstance() -> EntityManager {
        return instance
    }

    //MARK: public methods
    public func fetchAll <T : CoreDataObject> (type : T.Type) -> [T]? {
        let request : NSFetchRequest = type.fetchRequest()
        do {
            return try type.getContext().fetch(request) as? [T]
        }
        catch {
            return nil
        }
    }

}
