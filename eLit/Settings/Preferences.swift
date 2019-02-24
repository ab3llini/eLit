//
//  Settings.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 13/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import Foundation

struct CoreSettings : Codable {
    
    var host : String
    var gid : String
    
}

struct Switch {
    
    var text : String
    var value : Bool
    
}

struct UserSettings {
    
    var switches : [Switch] = []
    
}

enum UserSettingsSwitchType : Int {
    case updates = 0
    case homeRating = 1
    case hideIngredients = 2
    case hideRecipe = 3
}

class Preferences {
    
    public static let shared = Preferences()
    
    public var coreSettings : CoreSettings {
        
        return self.readPlist(named: "CoreSettings", codable: CoreSettings.self)!

    }
    
    private var userSettingsDict : Dictionary<String, Any>?
    
    public func userSettings() -> UserSettings {
        
        if (self.userSettingsDict == nil) {
            
            if let path = Bundle.main.path(forResource: "UserSettings", ofType: "plist") {
                
                let dict = NSMutableDictionary(contentsOfFile: path) as! Dictionary<String, Any>
                
                self.userSettingsDict = dict
            }
            else {
                self.userSettingsDict = Dictionary<String, Any>()
            }
            
        }
       
        var settings = UserSettings()
        let switches = self.userSettingsDict!["Switches"] as! Array<Dictionary<String, Any>>
        
        for sw in switches {
            settings.switches.append(Switch(text: sw["Key"] as! String, value: sw["Value"] as! Bool))
        }
        
        return settings
        
    }
    
    public func toggleUserSwitch(at index: Int) {
        
        var switches = self.userSettingsDict!["Switches"] as! Array<Dictionary<String, Any>>
        
        switches[index]["Value"] = !(switches[index]["Value"] as! Bool)
        
        self.userSettingsDict!["Switches"] = switches
        
        let savePath = Bundle.main.path(forResource: "UserSettings", ofType: "plist")!
        let data = NSMutableDictionary(dictionary: self.userSettingsDict! as NSDictionary)
        
        print(data)
        
        data.write(toFile: savePath, atomically: true)
        
    }
    
    public func getSwitch(for type : UserSettingsSwitchType) -> Bool {
    
        return Preferences.shared.userSettings().switches[type.rawValue].value
    
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
