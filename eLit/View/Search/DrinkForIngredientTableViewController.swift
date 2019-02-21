//
//  DrinkForIngredientTableViewController.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 25/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class DrinkForIngredientTableViewController: BlurredBackgroundTableViewController, UIViewControllerPreviewingDelegate {
    
    var withIngredient: Ingredient?
    var category: DrinkCategory?
    var vcForClass: ObjectClass!
    var segue: Navigation = .fromDrinkForIngredientToDrinkVC
    var drinks: [Drink] = []
    var categories: [DrinkCategory] = []
    let nib = "DrinkTableViewCell"
    var coreColors : [String : UIColor] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch self.vcForClass {
        case .ingredient?:
            self.segue = Navigation.fromDrinkForIngredientToDrinkVC
            withIngredient?.getImageAndColor(completion: { image, color in
                self.setBackgroundImage(image, withColor: color.withAlphaComponent(0.6))
            })
        case .category?:
            self.segue = Navigation.fromDrinkForIngredientToDrinkVC
            category?.getImageAndColor(completion: { image, color in
                self.setBackgroundImage(image, withColor: color.withAlphaComponent(0.6))
            })
        default:
            return
        }
        
        //Load nibs
        self.tableView.register(UINib.init(nibName: nib, bundle: nil), forCellReuseIdentifier: nib)
        
        //Register for 3D touch
        registerForPreviewing(with: self, sourceView: self.tableView)
        
        self.drinks = Model.shared.getDrinks()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch self.vcForClass {
        case .ingredient?:
            self.drinks = Model.shared.getDrinks().filter { drink in
                guard let ing = self.withIngredient else {
                    return false
                }
                return drink.ingredients().contains(ing)
            }
            self.title = "\(self.withIngredient?.name ?? "")"
        
        case .category?:
            self.drinks = Model.shared.getDrinks().filter { drink in
                guard let cat = self.category else {
                    return false
                }
                return drink.ofCategory == cat
            }
            self.title = "\(self.category?.name ?? "")"
        
        default:
            return
        }
        
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
        guard let path = tableView.indexPathForRow(at: location) else {
            return nil
        }
        
        switch path.section {
        default:
            //This will show the cell clearly and blur the rest of the screen for our peek.
            previewingContext.sourceRect = tableView.rectForRow(at: path)
            let drinkVC = storyboard?.instantiateViewController(withIdentifier: "drinkVC") as! DrinkViewController
            drinkVC.setDrink(drink: self.drinks[path.row])
            return drinkVC
        }
    }

    
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
