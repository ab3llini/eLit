//
//  Renderer.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 14/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit

class Renderer: NSObject {

    public static let shared = Renderer()
    
    private var coreColors : [String : UIColor] = [:]
    
    override init() {
        
        //Compute core colors once
        let drinks = Model.shared.getDrinks()
        
        for drink in drinks {
            
            if self.coreColors[drink.name!] == nil {
                
                let image = UIImage(named: drink.imageName!)
                let color = image!.getCenterPixelColor()
                
                
                self.coreColors[drink.name!] = color.adjust(hueBy: 0, saturationBy: 0.6, brightnessBy: 0.7)
                
            }
            
        }
        
    }
    
    public func getCoreColors() -> [String:UIColor] {
        
        return self.coreColors
        
    }
    
}
