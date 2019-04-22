//
//  BlurredBackground.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 25/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

protocol BlurredBackground : class {
    
    var animationDuration : TimeInterval { get set }
    var backgroundImageSize : CGSize! { get set }
    var backgroundImageView : UIImageView! { get set }
    var containerView : UIView! { get set }
    var visualEffectView : UIView? { get set }
    var contentModeFit : Bool! { get set }
    
}

extension BlurredBackground {
    
    public func initBackgroundImageView() {
    
        //Adding blurred background
        self.backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.backgroundImageSize.width, height: self.backgroundImageSize.height))
    
        // Set aspect fit
        self.backgroundImageView.contentMode = (contentModeFit) ? UIView.ContentMode.scaleAspectFit : UIView.ContentMode.scaleAspectFill
    
        // Add image view
        containerView.addSubview(self.backgroundImageView)
        
        if (Preferences.shared.getSwitch(for: .darkMode)) {
            
            containerView.backgroundColor = UIColor.black
            self.visualEffectView = self.containerView!.addBlurEffect(effect: .dark)
        }
        else {
            containerView.backgroundColor = UIColor.clear
            self.visualEffectView = self.containerView!.addBlurEffect(effect: .extraLight)
        }
    
    }
    
    // Changes the background image and color
    public func setBackgroundImage(_ image : UIImage?, withColor color : UIColor? = nil) {
        
        if (self.backgroundImageView == nil) {
            
            self.initBackgroundImageView()
            
        }
        
        UIView.transition(with: self.backgroundImageView,  duration: self.animationDuration, options: .transitionCrossDissolve, animations: {
            
            self.backgroundImageView.image = image
            if let color_ = color {
                self.backgroundImageView.backgroundColor = color_.withAlphaComponent(0.5)
            }
        }, completion: nil)
        
    }
    
    
}
