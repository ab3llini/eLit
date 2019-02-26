//
//  BlurredBackgroundTableViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 26/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit


class BlurredBackgroundTableViewController: UITableViewController, BlurredBackground, DarkModeBehaviour {
    
    var visualEffectView: UIView?
    var backgroundImageSize: CGSize!
    var containerView: UIView!
    
    
    @IBInspectable
    var animationDuration : TimeInterval = 0.5
    
    // Height of the blurred background image view
    @IBInspectable
    var backgroundImageViewHeight : CGFloat = 400
    
    // Speed ratio at which images slides away while scolling
    @IBInspectable
    var backgroundImageSpeedRatio : CGFloat = 0.5
    
    @IBInspectable
    var transparentNavBar : Bool = false
    
    @IBInspectable
    var largeTitles : Bool = true
    
    // Background view
    var backgroundImageView : UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a container view to attach image on top
        self.containerView = UIImageView()
        
        self.backgroundImageSize = CGSize(width: self.view.bounds.width, height: 400)

        // Empty setup
        self.initBackgroundImageView()
        
        DarkModeManager.shared.register(component: self)
        
        // Assign the container view as background view
        tableView.backgroundView = containerView
        
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = self.tableView.contentOffset.y + self.tableView.adjustedContentInset.top
        let origin = self.backgroundImageView.frame.size.height/2
        
        guard offset >= 0 else {
            return
        }
        
        self.backgroundImageView.center.y = origin - (offset * self.backgroundImageSpeedRatio)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let lvnc : LargeVbrantNavigatonController = self.navigationController as? LargeVbrantNavigatonController else {
            
            print("Warning: Using a Blurred VC without a proper nav controller")
            
            return
            
        }
        
        // Optimize nav controller
        lvnc.optimize(for: self)
        
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
