//
//  RecipeStep.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 29/12/2018.
//  Copyright © 2018 Alberto Mario Bellini. All rights reserved.
//

import UIKit
import CoreData

@objc(RecipeStep)
class RecipeStep: DrinkObject {
    //MARK: Attributes
    public override var description: String {
        let components = self.withComponents?.array as! [DrinkComponent]
        return  components.map({$0.description}).reduce("STEP:\n") {str, component in "\(str)\t\(component)"} +
            "\n" + ((self.stepDescription != nil) ? self.stepDescription! : "")
    }
    
    //MARK: Initializers
    convenience init(description: String, drinkComponents: [DrinkComponent]){
        self.init()
        self.stepDescription = description
        self.withComponents = NSOrderedSet(array: drinkComponents)
    }
    
    convenience init(drinkComponents: [DrinkComponent]) {
        self.init(description: "", drinkComponents: drinkComponents)
    }
    
    convenience init(dict: [String: Any]) {
        var components: [DrinkComponent] = []
        for c in dict["components"] as? [[String: Any]] ?? [] {
            components.append(DrinkComponent(dict: c))
        }
        self.init(drinkComponents: components)
        self.stepDescription = dict["step_description"] as? String ?? ""
        self.id = dict["id"] as? String ?? ""
        self.fingerprint = dict["fingerprint"] as? String ?? ""
    }
    
    override func update(with data: [String : Any], savePersistent: Bool = false) {
        self.stepDescription = data["step_description"] as? String ?? ""
        super.update(with: data, savePersistent: savePersistent)
    }
    
    
    //MARK: getter & setter
    func setDescription(description:String) {
        self.stepDescription = description
    }
    
    func translateToAttributedString() -> NSMutableAttributedString {
        
        let mString = NSMutableAttributedString(string: self.stepDescription!)
        let components = self.withComponents?.array as! [DrinkComponent]
        
        for (index, component) in components.enumerated() {
            
            guard let range = mString.string.range(of: "{\(index)}") else { continue }

            // Replacing i-th occurence of {i} with respective attributed string
            let attachment = NSTextAttachment()
            attachment.image = component.withIngredient?.image.resizeImage(targetSize: CGSize(width: 15, height: 15))
            
            let iconString = NSMutableAttributedString(attachment: attachment)
            let nameString = NSAttributedString(string: (component.withIngredient?.name)!)

            iconString.appendWith(" ")
            
            let color = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
            
            iconString.appendWith(color: color, weight: .semibold, ofSize: 16, nameString.string)
            
            let nsRange = NSRange(range, in: mString.string)
            
            mString.replaceCharacters(in: nsRange, with: iconString)
            
            
        }
        
        return mString
        
    }

}
