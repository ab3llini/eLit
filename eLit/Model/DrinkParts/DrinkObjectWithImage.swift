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
    
    internal var image: UIImage?
    internal var color: UIColor?
    
    private let animationDuration = 0.5
    
    var setImageQueue = DispatchQueue(label: "getImageQueue")
    
    func getImage(forceReload: Bool = false, completion: ((_ image: UIImage?) -> Void)? = nil) {
        
        
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
    
    

    func setImage (to imageView : UIImageView, condition : () -> Bool) {
        
        if condition() {
            
            self.setImage(to: imageView)
            
        }
    
    }
    
    func setImage (to imageView : UIImageView, then : (() -> Void)? = nil) {
        
        if self.image != nil {
            
            imageView.image = self.image
                        
            if let execute = then {
                execute()
            }
        }
        else {
            self.getImage() { image in
                
                imageView.transitionTo(image: image, duration: self.animationDuration)

                if let execute = then {
                    execute()
                }
            }
        }
        
    }
    
    func setColor (to view : UIView, alpha : CGFloat = 1) {
        
        if self.color != nil {
            UIView.animate(withDuration: self.animationDuration) {
                view.backgroundColor = self.color?.withAlphaComponent(alpha)
            }
        }
        else {
            self.getColor { (color) in
                UIView.animate(withDuration: self.animationDuration) {
                    view.backgroundColor = color.withAlphaComponent(alpha)
                }
            }
        }
        
    }
    
    func setImageAndColor(imageFor imageView : UIImageView, colorFor view: UIView, alpha : CGFloat = 1) {
        
        self.setImage(to: imageView)
        self.setColor(to: view, alpha: alpha)
        
    }
    
    func setImageAndColor(calling : @escaping (_ image : UIImage?, _ color: UIColor) -> Void) {
        
        if self.color == nil && self.image == nil {
            
            self.getImage { (image) in
                self.getColor(completion: { (color) in
                    calling(image, color)
                })
            }
            
        }
        else if self.color == nil && self.image != nil {
            
            self.getColor(completion: { (color) in
                calling(self.image, color)
            })
            
        }
        else if self.color != nil && self.image == nil {
            
            self.getImage { (image) in
                calling(image, self.color!)

            }
            
        }
        else {
            calling(self.image, self.color!)

        }
        
    }
    
    func getImageAndColor(completion: @escaping (_ image : UIImage?, _ color: UIColor) -> Void) {
        
        self.getImage { (image) in
            self.getColor(completion: { (color) in
                completion(image, color)
            })
        }
        
    }
    
    func getColor(completion: @escaping (_ color: UIColor) -> Void) {
        
        guard self.color == nil else {
            completion(self.color!)
            return
        }
        
        self.getImage { (image) in
            image?.getColors({ (colors) in
                
                self.color = colors.secondary.adjust(brightnessBy: 0.5)
                
                completion(self.color!)
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
