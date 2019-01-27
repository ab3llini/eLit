//
//  DrinkNavigationController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 19/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class LargeVbrantNavigatonController: UINavigationController, UINavigationControllerDelegate {

    var initComplete : Bool = false
    
    var blurredImageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        // Remove background image and color from navigaton bar and set
        
        // Turn on vibrancy
        self.navigationBar.isTranslucent = true
        
        // PRefers large titles
        self.navigationBar.prefersLargeTitles = true
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard !initComplete else {
            
            self.optimize()
            
            return
        }
        
        // Remove background image and color from navigaton bar and set
        
        let rect = CGRect(x: 0, y: 0, width: self.navigationBar.bounds.width, height: self.navigationBar.bounds.height - 10)
        
        // Create empty image view
        self.blurredImageView = UIImageView(frame: rect)
        
        // Add blur effect to the image view
        _ = self.blurredImageView.addBlurEffect(effect: .light)
        
        // Insert the image view
        
        self.navigationBar.subviews[0].insertSubview(self.blurredImageView, at: 0)
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        
        self.optimize()

        self.initComplete = true
        
    }
    
    private func optimize() {
        
        if (self.navigationBar.topItem?.title == nil) {
            
            self.blurredImageView.isHidden = true
            self.navigationBar.prefersLargeTitles = false
            
        }
        else {
            
            self.blurredImageView.isHidden = false
            self.navigationBar.prefersLargeTitles = true

            
        }
        
    }
    
  
}
