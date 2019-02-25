//
//  DarkModeManager.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 25/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit


protocol DarkModeBehaviour : class {
    
    func setDarkMode(enabled : Bool)
    
}

protocol DarkModeViewBehaviour : DarkModeBehaviour {
    var visualEffectView : UIView? { get set }
    var containerView : UIView! { get set }
}

protocol DarkModeViewControllerBehaviour : DarkModeViewBehaviour {
    
}

protocol DarkModeLabelBehaviour : DarkModeBehaviour {
    

}

protocol DarkModeImageViewBehaviour : DarkModeBehaviour {
    var visualEffectView : UIView? { get set }
}

extension DarkModeViewControllerBehaviour {
    
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

extension DarkModeLabelBehaviour where Self : AdaptiveLabel {
    
    internal func setDarkMode(enabled : Bool) {
                
        if (enabled) {
            
            self.textColor = .white
            
        }
        else {
            
            self.textColor = self.preferredColor
            
        }
    }
}

extension DarkModeImageViewBehaviour where Self : UIImageView {
    
    internal func setDarkMode(enabled : Bool) {
        
        if self.visualEffectView != nil && self.visualEffectView!.superview != nil {
            self.visualEffectView!.removeFromSuperview()
        }
        
        if (enabled) {
            self.visualEffectView = self.addBlurEffect(effect: .dark)
        }
        else {
            self.visualEffectView = self.addBlurEffect(effect: .extraLight)
        }
    }
}


extension DarkModeViewBehaviour {
    
    public func setDarkMode(enabled : Bool) {
        
        if self.visualEffectView != nil && self.visualEffectView!.superview != nil {
            self.visualEffectView!.removeFromSuperview()
        }
        
        if (self.containerView != nil) {
        
            if (enabled) {
                self.visualEffectView = self.containerView!.addBlurEffect(effect: .dark)
            }
            else {
                self.visualEffectView = self.containerView!.addBlurEffect(effect: .extraLight)
            }
        }
    }
}

class DarkModeManager {
    
    public static let shared = DarkModeManager()
    
    private var observers : [DarkModeBehaviour] = []
    
    public func register(view : DarkModeBehaviour) {
        
        self.observers.append(view)
        
    }
    
    public func triggerNotificationFor(state : Bool) {
        
        for observer in self.observers {
            
            observer.setDarkMode(enabled: state)
        
        }
        
    }
    
}
