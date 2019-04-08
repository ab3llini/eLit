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
    internal var colors: UIImageColors?
    
    private let animationDuration = 0.5
    
    func getImage(completion: CompletionHandler<UIImage>? = nil) {
        
        // The image has already been downloaded
        if let theImage = self.image, let theHandler = completion {
            theHandler(theImage)
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
        
        if self.colors?.primary == nil && self.image == nil {
            
            self.getImage { (image) in
                self.getColors(completion: { (colors) in
                    calling(image, colors.secondary)
                })
            }
            
        }
        else if self.colors?.primary == nil && self.image != nil {
            
            self.getColors(completion: { (colors) in
                calling(self.image, colors.secondary)
            })
            
        }
        else if self.colors != nil && self.image == nil {
            
            self.getImage { (image) in
                calling(image, self.colors!.secondary)
                
            }
            
        }
        else {
            calling(self.image, self.colors!.secondary)
            
        }
        
    }
    
    func getImageAndColor(completion: @escaping (_ image : UIImage?, _ colors: UIImageColors) -> Void) {
        
        self.getImage { (image) in
            self.getColors(completion: { (colors) in
                completion(image, colors)
            })
        }
        
    }
    
    func getColors(completion: @escaping (_ colors: UIImageColors) -> Void) {
        guard self.colors?.primary == nil else {
            completion(self.colors!)
            return
        }
        
        self.getImage { (image) in
            
            image.getColors({ (colors) in
                
                let result = UIImageColors(background: colors.background, primary: colors.primary, secondary: colors.secondary.adjust(brightnessBy: 0.5), detail: colors.detail)
                
                self.colors = result
                
                completion(result)
            })
        }
        
    }
    
    private func getImageData(forceReload: Bool, completion: ((_ image: UIImage) -> Void)?) {
        
        if (ImageQueue.shared.queue[self] == nil) {
            
            ImageQueue.shared.queue[self] = Queue<CompletionHandler?>()
            
        }
        
        if self.imageData != nil && (!forceReload) {
            
            return
        }
        
        guard let url = URL(string: Preferences.shared.coreSettings.host + self.imageURLString!) else {
            
            return
        }
        
        
        if (ImageQueue.shared.queue[self]!.items.count > 0) {
            
            // Already downloading image
            ImageQueue.shared.queue[self]!.enqueue(element: completion)
            
        }
        else {
            
            print("Requesting asset: \(url) [force reload = \(forceReload)]")
            
            ImageQueue.shared.queue[self]!.enqueue(element: completion)
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                guard let data = data, let _ = completion, error == nil else {                                                 // check for fundamental networking error
                    NSLog("error=\(String(describing: error))")
                    
                    DispatchQueue.main.async {
                        self.callCompletions(UIImage(named: "drink_placeholder")!)
                    }
                    
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    DispatchQueue.main.async {
                        self.callCompletions(UIImage(named: "drink_placeholder")!)
                    }
                    
                }
                else {
                    
                    DispatchQueue.main.async {
                        self.imageData = data
                        self.image = UIImage(data: data)
                        self.callCompletions(self.image!)
                        Model.shared.savePersistentModel()
                    }
                    
                }
                
            }
            
            task.resume()
            
        }
    }
    
    func callCompletions(_ image : UIImage) {
        
        
        while ImageQueue.shared.queue[self]!.items.count > 0 {
            
            if let completion = ImageQueue.shared.queue[self]!.dequeue() {
                
                completion!(image)
                
            }
        }
        
    }
    
    override func update(with data: [String : Any], savePersistent: Bool) {
        
        self.getImageData(forceReload: false, completion: { img in
            super.update(with: data, savePersistent: savePersistent)})
    }
    
}
