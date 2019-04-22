//
//  BlurredBackgroundViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 12/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit


class BlurredBackgroundViewController: UIViewController, BlurredBackground, DarkModeViewBehaviour {
    
    var contentModeFit: Bool!
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
    
    @IBInspectable
    var modeFit : Bool = true
    
    // Height of the blurred background image view
    var backgroundImageViewHeight : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentModeFit = modeFit

        self.backgroundImageViewHeight = (self.modeFit) ? self.view.bounds.height / 4 * 3 : self.view.bounds.height

        self.backgroundImageSize = CGSize(width: self.view.bounds.width, height: self.backgroundImageViewHeight)
        
        // Create a container view to attach image on top
        self.containerView = UIView(frame: self.view.bounds)
        
        self.initBackgroundImageView()
        
        DarkModeManager.shared.register(component: self)
        
        // Assign the container view as background view
        self.view.insertSubview(containerView, at: 0)
                
        if let img = self.backgroundImage {
            
            self.setBackgroundImage(img, withColor: self.backgroundImageColor)

        }    
    }
    
    func setDarkMode(enabled: Bool) {
        
        if self.visualEffectView != nil && self.visualEffectView!.superview != nil {
            self.visualEffectView!.removeFromSuperview()
        }
        
        
        if (self.containerView != nil) {
            
            if (enabled) {
                containerView.backgroundColor = UIColor.black
                self.visualEffectView = self.containerView!.addBlurEffect(effect: .dark)
            }
            else {
                containerView.backgroundColor = UIColor.clear
                self.visualEffectView = self.containerView!.addBlurEffect(effect: .extraLight)
            }
            
        }
        
    }

}
