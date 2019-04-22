//
//  DrinkNavigationController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 19/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class LargeVbrantNavigatonController: UINavigationController, UINavigationControllerDelegate, DarkModeBehaviour {

    var initComplete : Bool = false
    var blurredImageView : NavBarImageView!
    var prevVC : UIViewController!
    let color = UIColor(red: 236/255.0, green: 69/255.0, blue: 90/255.0, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Turn on vibrancy
        self.navigationBar.isTranslucent = true
        
        // PRefers large titles
        self.navigationBar.prefersLargeTitles = true
        
        self.delegate = self
        
        self.prevVC = self.visibleViewController
        
        self.navigationBar.tintColor = UIColor(red: 236/255.0, green: 69/255.0, blue: 90/255.0, alpha: 1)
                
        DarkModeManager.shared.register(component: self)
    
    }

    override func viewWillLayoutSubviews() {
    
        
        if !initComplete  {
            
            // Remove background image and color from navigaton bar and set
            let rect = CGRect(x: 0, y: 0, width: self.navigationBar.bounds.width, height: self.navigationBar.bounds.height - 10)
            
            // Create empty image view
            self.blurredImageView = NavBarImageView(frame: rect)
            
            // Add blur effect to the image view
            self.blurredImageView.setDarkMode(enabled: Preferences.shared.getSwitch(for: .darkMode))
            
            DarkModeManager.shared.register(component: self.blurredImageView)


            // Insert the image view
            
            self.navigationBar.subviews[0].insertSubview(self.blurredImageView, at: 0)
            
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.shadowImage = UIImage()
            
            self.initComplete = true
            
        }
        
        super.viewWillLayoutSubviews()
        
    }
    
    func optimize(for viewController : BlurredBackgroundTableViewController) {
        
        self.navigationBar.prefersLargeTitles = viewController.largeTitles
        self.blurredImageView.isHidden = viewController.transparentNavBar

    }
    
    func setDarkMode(enabled: Bool) {
        
        let textAttributes : [NSMutableAttributedString.Key : Any]
        
        if (enabled) {
            textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        }
        else {
            textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        }
        self.navigationBar.largeTitleTextAttributes = textAttributes
        self.navigationBar.titleTextAttributes = textAttributes
    }

}

class NavBarImageView : UIImageView, DarkModeImageViewBehaviour {
    
    var visualEffectView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
