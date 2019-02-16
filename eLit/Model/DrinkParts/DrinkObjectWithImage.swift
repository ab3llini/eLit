//
//  DrinkObjectWithImage.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 07/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

@objc(DrinkObjectWithImage)
class DrinkObjectWithImage: DrinkObject {
    
    var image: UIImage = UIImage()
    
    func setImage(forceReload: Bool = false) {
        if forceReload {
             getImageData(forceReload: true)
        }
        if let id = self.imageData {
            self.image = UIImage(data: id) ?? UIImage()
        }
        else {
            getImageData(forceReload: true)
            self.image = UIImage(data: self.imageData!) ?? UIImage()
        }
        
    }
    
    func setImage(forceReload: Bool = false, completion: (_ image: UIImage?) -> Void) {
        self.setImage(forceReload: forceReload)
        completion(self.image)
    }
    
    
    private func getImageData(forceReload: Bool) {
        if self.imageData != nil && (!forceReload) {
            return
        }
        
        guard let url = URL(string: self.imageURLString!) else {
            return
        }
        
        if let id: NSData = NSData(contentsOf: url) {
            self.imageData = id as Data
            self.image = UIImage(data: self.imageData!) ?? UIImage()
        } else { return }
    }

}
