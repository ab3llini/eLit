//
//  Renderer.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 14/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit
import UIImageColors

class Renderer: NSObject {

    public static let shared = Renderer()
    
    private var coreColors : [String : UIColor] = [:]
    
    override init() {
        
        //Compute core colors once
        let drinks = Model.shared.getDrinks()
        
        for drink in drinks {
            
            if self.coreColors[drink.name!] == nil {
                let image = drink.image
                let color = image.getColors().primary
                
                
                self.coreColors[drink.name!] = color!.adjust(hueBy: 0, saturationBy: 0, brightnessBy: 0.7)
                
            }
            
        }
        
    }
    
    public func getCoreColors() -> [String:UIColor] {
        
        return self.coreColors
        
    }
    
}
