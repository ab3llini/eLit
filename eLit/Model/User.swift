//
//  User.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 19/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import GoogleSignIn
import CoreData

@objc(User)
class User: CoreDataObject {
    
    var image: UIImage?
    
    convenience init(data : GIDGoogleUser) {
        self.init()
        self.updateUserData(data: data)
    }
    
    func updateUserData(data: GIDGoogleUser) {
        self.name = data.profile.givenName
        self.familyName = data.profile.familyName
        self.email = data.profile.email
        self.userID = data.userID
        self.imageURLString = data.profile.imageURL(withDimension: 500)?.absoluteString
        self.setImage(forceReload: true)
    }
    
    func setImage(forceReload: Bool = false) {
        guard let id = self.imageData, !forceReload else {
            getImageData(forceReload: true)
            return
        }
        
        self.image = UIImage(data: id)
    }
    
    func setImage(forceReload: Bool = false, completion: (_ image: UIImage?) -> Void) {
        self.setImage(forceReload: forceReload)
        completion(self.image)
    }
    
    
    private func getImageData(forceReload: Bool) {
        if self.imageData != nil && (!forceReload) {
            return
        }
        
        if let id: NSData = NSData(contentsOf: URL(string: self.imageURLString!)!) {
            self.imageData = id as Data
            self.image = UIImage(data: self.imageData!)
        } else { return }
    }
    
    func toDict() -> [String: Any] {
        var dict: [String: String] = [:]
        dict["name"] = self.name
        dict["family_name"] = self.familyName
        dict["email"] = self.email
        dict["user_id"] = self.userID
        dict["image_url"] = self.imageURLString
        
        return dict
    }
}
