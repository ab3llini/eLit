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
    internal var imageColors: UIImageColors?
    
    private let animationDuration = 0.5
    
    
    private func log(string : String) {
        print("[\(self.imageURLString ?? "Undefined")] -> \(string)")
    }
    
    public func getImage(completion: CompletionHandler<UIImage>? = nil) {
        
        if let cachedImage = self.image {
            self.log(string: "Image is present in cache")
            // The image has already been downloaded, call the handler with the cached copy
            if let handler = completion {
                self.log(string: "Calling handler")
                handler(cachedImage)
            }
        }
        else {
            
            self.log(string: "No image in cache")
            
            if let cachedImageData = self.imageData {
                
                self.log(string: "ImageData is present in cache")
                
                // Step 1: Create an image out of the cached data
                self.image = UIImage(data: cachedImageData)
                
                // Step 3: If present, call the handler. We expect the image to init successfully
                // However, we provide a default image in case of failure
                if let handler = completion {
                    self.log(string: "Calling handler (might be default image if image init fails)")
                    handler(self.image ?? ResourceManager.defaultImagePlaceholder)
                }
                
            }
            
            else if let consistentImageURL = self.imageURLString {
                
                self.log(string: "URL is consistent")
                
                // We have a valid image relative URL, download it
                // The image needs to be downloaded, use the resource manager to do so
                ResourceManager.shared.fetchImageData(from: consistentImageURL) { (data) in
                    
                    self.log(string: "ResourceManager returned some data")
                    
                    // Avoid multiple assignments due to multiple callbacks on same object
                    if self.imageData == nil {
                        
                        self.log(string: "Saving data and creating image")

                        
                        // The returned data is consistent ?
                        if let consistentData = data {
                            self.log(string: "Data is consistent")

                            // Step 1: Save the image data blob
                            self.imageData = consistentData
                            
                            // Step 2: Create an image out of it
                            self.image = UIImage(data: consistentData)
                            
                            // Step 3: If present, call the handler. We expect the image to init successfully
                            // However, we provide a default image in case of failure
                            if let handler = completion {
                                self.log(string: "Calling handler (might be default image if image init fails)")
                                handler(self.image ?? ResourceManager.defaultImagePlaceholder)
                            }
                            
                            // Step 4, AFTER calling the handler, save the persistent model
                            Model.shared.savePersistentModel()
                        }
                        else {
                            self.log(string: "Data is not consistent")

                            // We got inconsistent data (aka data = nil). Call the handler with the default image
                            if let handler = completion {
                                self.log(string: "Calling handler with default image")
                                handler(ResourceManager.defaultImagePlaceholder)
                            }
                        }
                    }
                    else {
                        self.log(string: "Throwing data because it is already cached")

                    }
                }
            }
            else {
                self.log(string: "URL is NOT consistent")
                // We dont have a valid URL, notify and load the default image
                if let handler = completion {
                    self.log(string: "Calling handler with default image")
                    handler(ResourceManager.defaultImagePlaceholder)
                }
            }
        }
    }
    
    
    func setImage (to imageView : UIImageView, condition : () -> Bool) {
        
        if condition() {
            
            self.setImage(to: imageView)
            
        }
        
    }
    
    func setImage (to imageView : UIImageView, then : (() -> Void)? = nil) {
        
        self.getImage() { image in
            
            DispatchQueue.main.async {
                if (imageView.image == nil) {
                    imageView.image = image
                } else {
                    
                    imageView.transitionTo(image: image, duration: self.animationDuration)
                    
                }
                
                if let execute = then {
                    execute()
                }
            }
            
            
        }
        
    }
    
    func setColor (to view : UIView, alpha : CGFloat = 1) {
        
        self.getColors { (colors) in
            UIView.animate(withDuration: self.animationDuration) {
                view.backgroundColor = colors.secondary.withAlphaComponent(alpha)
            }
        }
    }
    
    func setImageAndColor(imageFor imageView : UIImageView, colorFor view: UIView, alpha : CGFloat = 1) {
        
        self.setImage(to: imageView)
        self.setColor(to: view, alpha: alpha)
        
    }
    
    func setImageAndColor(calling : @escaping (_ image : UIImage?, _ color: UIColor) -> Void) {
        
        self.getImage { (image) in
            self.getColors(completion: { (colors) in
                calling(image, colors.secondary)
            })
        }
        
    }
    
    func getImageAndColor(completion: @escaping (_ image : UIImage?, _ colors: UIImageColors) -> Void) {
        
        self.getImage { (image) in
            self.getColors(completion: { (colors) in
                completion(image, colors)
            })
        }
        
    }
    
    func getColors(completion: @escaping CompletionHandler<UIImageColors>) {
        
        if let cachedImageColors = self.imageColors, let _ = self.imageColors?.primary {
            self.log(string: "ImageColors are present in cache")
            completion(cachedImageColors)
        }
        else {
            
            self.log(string: "ImageColors NOT present in cache, will compute them")

            self.getImage { (image) in
                
                image.getColors({ (colors) in
                    
                    let result = UIImageColors(background: colors.background, primary: colors.primary, secondary: colors.secondary.adjust(brightnessBy: 0.5), detail: colors.detail)
                    
                    self.imageColors = result
                    
                    self.log(string: "ImageColors computed. Calling handler")
                    completion(result)
                    
                })
            }
        }
    }
    
    override func update(with data: [String : Any], savePersistent: Bool) {
        
        self.imageData = nil
        self.imageColors = nil
        self.image = nil
        
        self.getImage { (image) in
            super.update(with: data, savePersistent: savePersistent)
        }
        
    }
    
}
