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
    
    var image: UIImage?
    
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
        
        guard let url = URL(string: self.imageURLString!) else {
            return
        }
        
        if let id: NSData = NSData(contentsOf: url) {
            self.imageData = id as Data
            self.image = UIImage(data: self.imageData!)
        } else { return }
    }

}
