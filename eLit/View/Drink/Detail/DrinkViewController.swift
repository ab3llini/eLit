//
//  DrinkViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 17/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit

class DrinkViewController: BlurredBackgroundTableViewController {
    
    var drink : Drink!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Register nibs
        self.tableView.register(UINib(nibName: "DrinkImageTableViewCell", bundle: nil), forCellReuseIdentifier: "DrinkImageTableViewCell")
        
        // Transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Add negative inset to account for nav bar
        self.tableView.contentInset = UIEdgeInsets(top: -50, left: 0, bottom: 0, right: 0)
        

    }
    
    
    public func setDrink(drink : Drink) {
        
        // Set drink
        self.drink = drink
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Layout content
        self.layoutContent()
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func layoutContent() {
        
        self.setBackgroundImage(UIImage(named: self.drink.image!)!, withColor: Renderer.shared.getCoreColors()[self.drink.name!]!)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
            let cell : DrinkImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DrinkImageTableViewCell") as! DrinkImageTableViewCell
            
            cell.imageViewContainer.image = UIImage(named: self.drink.image!)!
            cell.drinkNameLabel.text = self.drink.name
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
}
