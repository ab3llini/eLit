//
//  BlurredBackgroundTableViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 26/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class BlurredBackgroundTableViewController: UITableViewController {
    
    // Height of the blurred background image view
    @IBInspectable
    var backgroundImageViewHeight : CGFloat = 400
    
    // Speed ratio at which images slides away while scolling
    @IBInspectable
    var backgroundImageSpeedRatio : CGFloat = 0.8
    
    @IBInspectable
    var transparentNavBar : Bool = false
    
    @IBInspectable
    var largeTitles : Bool = true
    
    // Background view
    var backgroundImageView : UIImageView!

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
        
    }
    
    // Changes the background image and color
    public func setBackgroundImage(_ image : UIImage, withColor color : UIColor) {
        
        UIView.transition(with: self.backgroundImageView,  duration: 0.75, options: .transitionCrossDissolve, animations: {
            
            self.backgroundImageView.image = image
            self.backgroundImageView.backgroundColor = color.withAlphaComponent(0.4)
            
        }, completion: nil)
        
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
    

}
