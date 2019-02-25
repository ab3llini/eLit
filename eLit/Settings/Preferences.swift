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
    case darkMode
    case homeRating
    case hideIngredients
    case hideRecipe
}

class Preferences {
    
    public static let shared = Preferences()
    
    public var coreSettings : CoreSettings {
        
        return self.readPlist(named: "CoreSettings", codable: CoreSettings.self)!

    }
    
    private var userSettingsDict : Dictionary<String, Any>?
    private var _userSettings : UserSettings?
    
    public var userSettings : UserSettings {
        
        get {
            
            if (_userSettings == nil) {
                
                _userSettings = computeUserSettings()
                
            }
            
            return _userSettings!
            
        }
        
        set (value) {
            
            _userSettings = value
            
        }
        
    }
    
    
    private func computeUserSettings() -> UserSettings {
        
        var settings = UserSettings()
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        
        let path = documentsDirectory.appendingPathComponent("UserSettings.plist")
        let fileManager = FileManager.default
        
        // Delete plist stored in file manager
//        do {
//            try fileManager.removeItem(atPath: path)
//        }
//        catch let e {
//
//            print(e)
//
//        }
        //Check if file exists, if not copy the plist
        if !fileManager.fileExists(atPath: path) {
            
            guard let bundlePath = Bundle.main.path(forResource: "UserSettings", ofType: "plist") else {
                return settings
            }
            
            do {
                try fileManager.copyItem(atPath: bundlePath, toPath: path)
                
            } catch let error as NSError {
                
                print("Unable to copy file. ERROR: \(error.localizedDescription)")
                
            }
        }
        
        
        
        let myDict = NSDictionary(contentsOfFile: path)
        
        if let dict = myDict {
            
            self.userSettingsDict = (dict as! Dictionary<String, Any>)
            
            let switches = self.userSettingsDict!["Switches"] as! Array<Dictionary<String, Any>>
            
            for sw in switches {
                settings.switches.append(Switch(text: sw["Key"] as! String, value: sw["Value"] as! Bool))
            }
            
            return settings
            
        } else {
            
            print("WARNING: Couldn't create dictionary from UserSettings.plist! Default values will be used!")
            
            self.userSettingsDict = Dictionary<String, Any>()
            
            return settings
        }
        
    }
    
    
    public func toggleUserSwitch(at index: Int) {
        
        var switches = self.userSettingsDict!["Switches"] as! Array<Dictionary<String, Any>>
        
        switches[index]["Value"] = !(switches[index]["Value"] as! Bool)
        
        self.userSettingsDict!["Switches"] = switches
        
        let data = NSMutableDictionary(dictionary: self.userSettingsDict! as NSDictionary)
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent("UserSettings.plist")
        
        data.write(toFile: path, atomically: false)
        
        // Re-compute property
        self.userSettings = self.computeUserSettings()
    }
    
    public func getSwitch(for type : UserSettingsSwitchType) -> Bool {
    
        return Preferences.shared.userSettings.switches[type.rawValue].value
    
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
