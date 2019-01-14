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
    
    override func awakeFromNib() {
        
        //Set datasource
        self.dataSource = self
        
        //Load nibs
        for nib in nibs {
            
            self.register(UINib.init(nibName: nib, bundle: nil), forCellReuseIdentifier: nib)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.count + 1 //For header cell
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
            
            
            let drink : Drink = drinks[indexPath.row - 1]
            
            let color = Renderer.shared.getCoreColors()[drink.description]!
            let image = UIImage(named: drink.image!)!
            cell.setDrink(drink: drink, withImage: image, andColor: color)
            
            return cell
        }
       
        
        
       
    }
    

}
