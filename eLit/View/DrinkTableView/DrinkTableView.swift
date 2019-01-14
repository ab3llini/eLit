//
//  DrinkTableView.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 07/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit

struct CellRenderingData {
    let image : UIImage
    let coreColor : UIColor
    
}

class DrinkTableView: UITableView, UITableViewDataSource {
    
    let nibs = ["DrinkTableViewTableViewCell", "HeaderTableViewCell"]
    
    //Load drinks
    let drinks = Model.shared.getDrinks()
    var renderingData : [String : CellRenderingData] = [:]
    
    override func awakeFromNib() {
        
        //Set datasource
        self.dataSource = self
        
        //Load nibs
        for nib in nibs {
            
            self.register(UINib.init(nibName: nib, bundle: nil), forCellReuseIdentifier: nib)
            
        }
        
        
        //Preload images and compute core color - please keep img resolution low in order not to saturate ram
        //This might slow down table load times with lots of images - beware!
        
        for drink in drinks {
            
            if renderingData[drink.description] == nil {
                
                let image = UIImage(named: drink.image!)
                let color = image!.getCenterPixelColor()
                let newData = CellRenderingData(image: image!, coreColor: color)
                
                renderingData[drink.description] = newData
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
        
            //Header
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
            
            return cell
            
        }
        else {
         
            //Drinks
            let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkTableViewTableViewCell", for: indexPath) as! DrinkTableViewTableViewCell
            
            
            let drink : Drink = drinks[indexPath.row]
            let data : CellRenderingData = renderingData[drink.description]!
            cell.setDrink(drink: drink, withRenderingData: data)
            
            return cell
        }
       
        
        
       
    }
    

}
