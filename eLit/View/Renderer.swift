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
            
            if self.coreColors[drink.description] == nil {
                
                let image = UIImage(named: drink.image!)
                self.coreColors[drink.description] = image!.getCenterPixelColor()
                
            }
            
        }
        
    }
    
    public func getCoreColors() -> [String:UIColor] {
        
        return self.coreColors
        
    }
    
}
