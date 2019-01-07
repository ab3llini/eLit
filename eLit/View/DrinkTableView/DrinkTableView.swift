//
//  DrinkTableView.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 07/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit

class DrinkTableView: UITableView, UITableViewDataSource {
    
    //Load drinks
    let drinks = Model.getInstance().getDrinks()
    
    override func awakeFromNib() {
        
        //Set datasource
        self.dataSource = self
        
        //Load nib
        self.register(UINib.init(nibName: "DrinkTableViewTableViewCell", bundle: nil), forCellReuseIdentifier: "DrinkTableViewTableViewCell")
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let drink : Drink = drinks[indexPath.row]
        let img = UIImage(named: drink.image!)
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkTableViewTableViewCell") as! DrinkTableViewTableViewCell
        
        cell.setDrink(drink: drink, withImage: img!)
        
        return cell
        
       
    }
    

}
