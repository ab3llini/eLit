//
//  DrinkTableViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 17/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit

class DrinkTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {


    let nibs = ["DrinkTableViewTableViewCell", "HeaderTableViewCell"]
    
    //Load drinks
    let drinks = Model.shared.getDrinks()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Load nibs
        for nib in nibs {
            
            self.tableView.register(UINib.init(nibName: nib, bundle: nil), forCellReuseIdentifier: nib)
            
        }
        
        //Register for 3D touch
        registerForPreviewing(with: self, sourceView: self.tableView)
        
        
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        show(viewControllerToCommit, sender: self)
        
        //present(viewControllerToCommit, animated: true, completion: nil)
        
    }
    
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRow(at: location) {
            
            if (indexPath.row == 1) { return nil }
            
            //This will show the cell clearly and blur the rest of the screen for our peek.
            previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
            
            let drinkVC = storyboard?.instantiateViewController(withIdentifier: "drinkVC") as! DrinkViewController

            return drinkVC
            
        }
        return nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return drinks.count + 1 //For header cell
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (indexPath.row == 0) {
            
            //Header
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
            
            return cell
            
        }
        else {
            
            //Drinks
            let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkTableViewTableViewCell", for: indexPath) as! DrinkTableViewCell
            
            
            let drink : Drink = drinks[indexPath.row - 1]
            
            let color = Renderer.shared.getCoreColors()[drink.name!]!
            let image = UIImage(named: drink.image!)!
            
            cell.setDrink(drink: drink, withImage: image, andColor: color)
            
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: Navigation.toDrinkVC.rawValue, sender: self)
        
    }
    

    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */



}
