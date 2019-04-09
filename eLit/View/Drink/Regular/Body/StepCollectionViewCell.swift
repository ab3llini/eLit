//
//  StepCollectionViewCell.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 01/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class StepCollectionViewCell: UICollectionViewCell, DarkModeBehaviour {

    @IBOutlet weak var stepDescription: AdaptiveLabel!
    @IBOutlet weak var stepNumber: UILabel!
    @IBOutlet weak var containerView: ContainerView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    private var step : RecipeStep!
    private var vc : DrinkViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setVC (_ vc : DrinkViewController) {
        self.vc = vc
    }
    
    func setStep(_ step : RecipeStep, forIndex index : Int) {
        
        self.step = step
        self.stepNumber.text = "Step \(index + 1)"
        
        self.step.setAttributedString(completion: { (string) in
            self.stepDescription.attributedText = string
        })
        
        // Rotate the image view by 45 degrees
        self.backgroundImageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 10)
        
        
        // Add blur effect
        _ = self.blurView.addBlurEffect(effect: .extraLight)
        
        // Set default state
        self.setDarkMode(enabled: Preferences.shared.getSwitch(for: .darkMode))
        
        // Register for dark mode updates
        DarkModeManager.shared.register(component: self)
        
        // Add a very light border to the cell
        containerView.layer.borderWidth = 1
        
        self.setBackgroundImage()
        
    }
    private func setBackgroundImage() {
        
        let comps = self.step.withComponents!.array as! [DrinkComponent]
        
        if (comps.count > 0) {
            if let ing = comps[0].withIngredient {
                
                ing.setImage(to: self.backgroundImageView)
                
            }
        }
    }
    
    func setDarkMode(enabled: Bool) {
        if (enabled) {
            
            self.blurView.alpha = 0
            containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
            
        }
        else {
            self.blurView.alpha = 0.5
            containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
            
            
        }
    }

}
