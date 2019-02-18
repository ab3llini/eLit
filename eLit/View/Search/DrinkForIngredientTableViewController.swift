//
//  DrinkForIngredientTableViewController.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 25/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class DrinkForIngredientTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    var withIngredient: Ingredient?
    var segue: Navigation = .fromDrinkForIngredientToDrinkVC
    var drinks: [Drink] = []
    let nib = "DrinkTableViewCell"
    var coreColors : [String : UIColor] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.segue = Navigation.fromDrinkForIngredientToDrinkVC
        
        //Load nibs
        self.tableView.register(UINib.init(nibName: nib, bundle: nil), forCellReuseIdentifier: nib)
        
        //Register for 3D touch
        registerForPreviewing(with: self, sourceView: self.tableView)
        
        self.drinks = Model.shared.getDrinks()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.drinks = Model.shared.getDrinks().filter { drink in
            guard let ing = self.withIngredient else {
                return false
            }
            return drink.ingredients().contains(ing)
        }
        self.title = "Drinks with \"\(self.withIngredient?.name ?? "")\""
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return drinks.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: self.segue.rawValue, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Drinks
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkTableViewCell", for: indexPath) as! DrinkTableViewCell
        
        let drink : Drink = drinks[indexPath.row]
        
        cell.setDrink(drink: drink)
        
        return cell
    }
   
    //MARK: preview
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let path = tableView.indexPathForRow(at: location)!
        
        switch path.section {
        default:
            //This will show the cell clearly and blur the rest of the screen for our peek.
            previewingContext.sourceRect = tableView.rectForRow(at: path)
            let drinkVC = storyboard?.instantiateViewController(withIdentifier: "drinkVC") as! DrinkViewController
            drinkVC.setDrink(drink: self.drinks[path.row])
            return drinkVC
        }
    }


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let v = segue.destination as! DrinkViewController
        if let index = self.tableView.indexPathForSelectedRow {
            v.setDrink(drink: drinks[index.row])
        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
