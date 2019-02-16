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
    
    private var drinkCoreColors : [String : UIColor] = [:]
    private var categoryCoreColors : [String : UIColor] = [:]
    private var ingredientCoreColors : [String : UIColor] = [:]
    
    override init() {
        
        
        //Compute core colors
        for drink in Model.shared.getDrinks() {
            
            if self.drinkCoreColors[drink.name!] == nil {
                let image = drink.image
                let color = image.getColors().primary
                
                self.drinkCoreColors[drink.name!] = color!.adjust(hueBy: 0, saturationBy: 0, brightnessBy: 0.7)
                
            }
            
        }
        
        //Compute core colors
        for category in Model.shared.getCategories() {
            
            if self.categoryCoreColors[category.name!] == nil {
                let image = category.image
                let color = image.getColors().primary
                
                self.categoryCoreColors[category.name!] = color!.adjust(hueBy: 0, saturationBy: 0, brightnessBy: 0.7)
                
            }
            
        }
        
        
    }
    
    public func getDrinkCoreColors() -> [String:UIColor] {
        
        return self.drinkCoreColors
        
    }
    
    public func getCategoryCoreColors() -> [String:UIColor] {
        
        return self.categoryCoreColors
        
    }
    
}
