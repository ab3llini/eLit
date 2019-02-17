//
//  Settings.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 13/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import Foundation

struct Settings : Codable {
    
    var host : String
    var gid : String
    
}

class Preferences {
    
    public static let shared = Preferences()
    
    public var settings : Settings {
        
        return self.readPlist(named: "Settings", codable: Settings.self)!

    }
    
    private func readPlist <T : Codable> (named : String, codable : T.Type) -> T? {
        
        if  let path = Bundle.main.path(forResource: named, ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path),
            let preferences = try? PropertyListDecoder().decode(codable, from: xml)
        {
                return preferences
        }
        else {
            
            return nil
            
        }
        
    }
    
}
