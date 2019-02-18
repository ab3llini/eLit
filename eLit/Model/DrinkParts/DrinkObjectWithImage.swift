//
//  DrinkObjectWithImage.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 07/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import UIImageColors

@objc(DrinkObjectWithImage)
class DrinkObjectWithImage: DrinkObject {
    
    var image: UIImage?
    var color: UIColor?
    
    func setImage(forceReload: Bool = false, completion: ((_ image: UIImage?) -> Void)? = nil) {
        if forceReload {
            getImageData(forceReload: true, completion: completion)
        }
        // The image is already initialized
        if let img = self.image, let actualCompletion = completion {
            DispatchQueue.main.async {
                actualCompletion(img)
            }
            return
        }
        // The image is not initialized but is present in the database
        if let id = self.imageData {
            self.image = UIImage(data: id) ?? UIImage()
            if let actualCompletion = completion {
                DispatchQueue.main.async {
                    actualCompletion(self.image)
                }
            }
        } else {
            getImageData(forceReload: true, completion: completion)

        }
    }
    
    func setImageAndColor(completion: @escaping (_ image : UIImage?, _ color: UIColor) -> Void) {
        
        self.setImage { (image) in
            self.setColor(completion: { (color) in
                completion(image, color)
            })
        }
        
    }
    
    func setColor(completion: @escaping (_ color: UIColor) -> Void) {
        
        guard self.color == nil else {
            completion(self.color!)
            return
        }
        
        self.setImage { (image) in
            image?.getColors({ (colors) in
                completion(colors.primary.adjust(brightnessBy: 0.4))
            })
        }
        
    }
    
    private func getImageData(forceReload: Bool, completion: ((_ image: UIImage?) -> Void)?) {
        if self.imageData != nil && (!forceReload) {
            return
        }
        
        guard let url = URL(string: Preferences.shared.settings.host + self.imageURLString!) else {
            return
        }
        
        print("Requesting asset: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let actualCompletion = completion, error == nil else {                                                 // check for fundamental networking error
                NSLog("error=\(String(describing: error))")
                if let actualCompletion = completion {
                    DispatchQueue.main.async {
                        actualCompletion(UIImage())
                    }
                }
                return
            }
        
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                DispatchQueue.main.async {
                    actualCompletion(UIImage())
                }
                
            }
            else {
                self.imageData = data
                self.image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    actualCompletion(self.image)
                    Model.shared.savePersistentModel()
                }
                
            }
            
            
            
            
            
        }
        
        task.resume()
    }
    
    override func update(with data: [String : Any], savePersistent: Bool) {
        self.getImageData(forceReload: true, completion: { img in super.update(with: data, savePersistent: savePersistent)})
    }

}
