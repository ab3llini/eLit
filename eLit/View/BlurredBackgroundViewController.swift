//
//  BlurredBackgroundViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 12/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class BlurredBackgroundViewController: UIViewController {
    
    
    @IBInspectable
    var animationDuration : TimeInterval = 0.5

    // Height of the blurred background image view
    @IBInspectable
    var backgroundImageViewHeight : CGFloat = 400
    
    @IBInspectable
    var transparentNavBar : Bool = false
    
    @IBInspectable
    var largeTitles : Bool = true
    
    // Background view
    var backgroundImageView : UIImageView!
    
    // Background view
    @IBInspectable
    var backgroundImage : UIImage?
    
    // Background view
    @IBInspectable
    var backgroundImageColor : UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding blurred background
        self.backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: self.backgroundImageViewHeight))
        
        // Set aspect fit
        self.backgroundImageView.contentMode = .scaleAspectFit
        
        // Create a container view to attach image on top
        let containerView = UIView(frame: self.view.bounds)
        
        // Setup background color
        containerView.backgroundColor = UIColor.clear
        
        // Add image view
        containerView.addSubview(self.backgroundImageView)
        
        // Add blur
        _ = containerView.addBlurEffect(effect: .extraLight)

        
        // Assign the container view as background view
        self.view.insertSubview(containerView, at: 0)
                
        if let img = self.backgroundImage {
            
            if let color = self.backgroundImageColor {
                
                self.setBackgroundImage(img, withColor: color)
                
            }
            
        }
        
        
        
    }
    
    // Changes the background image and color
    public func setBackgroundImage(_ image : UIImage?, withColor color : UIColor) {
        
        UIView.transition(with: self.backgroundImageView,  duration: self.animationDuration, options: .transitionCrossDissolve, animations: {
            
            self.backgroundImageView.image = image
            self.backgroundImageView.backgroundColor = color.withAlphaComponent(0.4)
            
        }, completion: nil)
        
    }
    

}
