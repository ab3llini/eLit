//
//  BlurredBackgroundViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 12/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit


class BlurredBackgroundViewController: UIViewController, BlurredBackground, DarkModeViewBehaviour {
    
    var containerView: UIView!
    var backgroundImageSize: CGSize!
    var visualEffectView: UIView?
    
    @IBInspectable
    var animationDuration : TimeInterval = 0.5

    
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

        self.backgroundImageSize = CGSize(width: self.view.bounds.width, height: 400)
        
        // Create a container view to attach image on top
        self.containerView = UIView(frame: self.view.bounds)
        
        self.initBackgroundImageView()
        
        DarkModeManager.shared.register(view: self)
        
        // Assign the container view as background view
        self.view.insertSubview(containerView, at: 0)
                
        if let img = self.backgroundImage {
            
            if let color = self.backgroundImageColor {
                
                self.setBackgroundImage(img, withColor: color)
                
            }
            
        }
        
        
        
    }    

}
