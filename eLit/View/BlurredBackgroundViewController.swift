//
//  BlurredBackgroundViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 12/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class BlurredBackgroundViewController: UITableViewController {

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
        self.backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: self.backgroundImageViewHeight))
        
        // Create a container view to attach image on top
        let containerView = UIImageView()
        
        // Setup background color
        containerView.backgroundColor = UIColor.white
        
        // Add image view
        containerView.addSubview(self.backgroundImageView)
        
        // Add blur
        _ = containerView.addBlurEffect(effect: .extraLight)
        
        // Set aspect fit
        self.backgroundImageView.contentMode = .scaleAspectFit
        
        // Assign the container view as background view
        tableView.backgroundView = containerView
        
        if let img = self.backgroundImage {
            
            if let color = self.backgroundImageColor {
                
                self.setBackgroundImage(img, withColor: color)
                
            }
            
        }
        
    }
    
    // Changes the background image and color
    public func setBackgroundImage(_ image : UIImage, withColor color : UIColor) {
        
        UIView.transition(with: self.backgroundImageView,  duration: 0.75, options: .transitionCrossDissolve, animations: {
            
            self.backgroundImageView.image = image
            self.backgroundImageView.backgroundColor = color.withAlphaComponent(0.4)
            
        }, completion: nil)
        
    }
    

}
