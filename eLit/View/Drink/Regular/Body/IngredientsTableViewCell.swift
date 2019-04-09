//
//  IngredientsTableViewCell.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 29/03/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

protocol ComponentViewDelegate {
    
    func componentView (_ view : ComponentView, didSelectComponent component: Component)
    
}

class ComponentView : UIView, DarkModeBehaviour {
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var ingredientName: AdaptiveLabel!
    @IBOutlet weak var qtyLabel: AdaptiveLabel!
    @IBOutlet weak var unitLabel: AdaptiveLabel!
    @IBOutlet weak var containerView: ContainerView!
    @IBOutlet weak var ingredientImage: UIImageView!
    
    var component : Component!
    var delegate : ComponentViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // The element is hidden by default
        self.alpha = 0
        
        // Register to clicks
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.notifyTouchUpInside)))
        
    }
    
    @objc func notifyTouchUpInside() {
        if let consistentDelegate = delegate {
            consistentDelegate.componentView(self, didSelectComponent: self.component)
        }
    }

    
    private func setBackgroundImage() {
        
        self.component.setImage { (image) in
            self.backgroundImageView.image = image
            self.ingredientImage.image = image
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
    
    
    public func setComponent(_ component : Component) {
        
        self.component = component
        
        // Enable component
        self.alpha = 1
        
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
        
        
        var qty : String
        if component.qty == 0 {
            qty = component.unit.uppercased()
            self.unitLabel.text = ""
        }
        else {
            if floor(component.qty) == component.qty {
                qty = String(format: "%.0f", component.qty)
            } else if (component.qty * 10) == floor(component.qty * 10) {
                qty = String(format: "%.1f", component.qty)
            } else {
                qty = String(format: "%.2f", component.qty)
            }
            self.unitLabel.text = component.unit.uppercased()
        }
        
        self.qtyLabel.text = qty
        self.ingredientName.text = component.name
        
    }
    
}

protocol IngredientsTableViewCellDelegate {
    func ingredientsTableViewCell(_ cell : IngredientsTableViewCell, didSelectComponent component: Component, for view : ComponentView)
}

class IngredientsTableViewCell: UITableViewCell, ComponentViewDelegate {
    
    @IBOutlet weak var leftComponent: ComponentView!
    @IBOutlet weak var centerComponent: ComponentView!
    @IBOutlet weak var rightComponent: ComponentView!
    
    var delegate : IngredientsTableViewCellDelegate?
    
    override func awakeFromNib() {
        leftComponent.delegate = self
        centerComponent.delegate = self
        rightComponent.delegate = self
    }
    
    func componentView(_ view: ComponentView, didSelectComponent component: Component) {
        if let consistentDelegate = self.delegate {
            consistentDelegate.ingredientsTableViewCell(self, didSelectComponent: component, for: view)
        }
    }
}

