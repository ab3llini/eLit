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
        self.setImage()
    }
    
    func setImage() {
        guard let id = self.imageData else {
            getImageData()
            return
        }
        self.image = UIImage(data: id)
    }
    
    func setImage(completion: (_ image: UIImage?) -> Void) {
        self.setImage()
        completion(self.image)
    }
    
    
    private func getImageData() {
        if self.imageData != nil {
            return
        }
        
        if let id: NSData = NSData(contentsOf: URL(string: self.imageURLString!)!) {
            self.imageData = id as Data
            self.image = UIImage(data: self.imageData!)
        } else { return }
    }
}
