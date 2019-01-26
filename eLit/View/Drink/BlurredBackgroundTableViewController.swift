//
//  BlurredBackgroundTableViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 26/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class BlurredBackgroundTableViewController: UITableViewController {
    
    // Background view
    var backgroundImageView : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //Adding blurred background
        self.backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 400)) // 250 + 100
        
        // Create a container view to avoid streatch
        let containerView = UIImageView()
        
        // Setup background color
        containerView.backgroundColor = UIColor.white
        
        // Add image view
        containerView.addSubview(self.backgroundImageView)
        
        // Add ONCE ONLY blur
        _ = containerView.addBlurEffect(effect: .extraLight)
        
        // Set ONCE ONLY aspect fit
        self.backgroundImageView.contentMode = .scaleAspectFit
        
        // Assign ONCE ONLY bg image
        tableView.backgroundView = containerView
    }

    public func setBackgroundImage(_ image : UIImage, withColor color : UIColor) {
        
        UIView.transition(with: self.backgroundImageView,  duration: 0.75, options: .transitionCrossDissolve, animations: {
            
            self.backgroundImageView.image = image
            self.backgroundImageView.backgroundColor = color.withAlphaComponent(0.4)
            
        }, completion: nil)
        
    }

}
