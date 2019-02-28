//
//  SearchTableViewController.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 24/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class SearchTableViewController: BlurredBackgroundTableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    var searchController = UISearchController()
    var drinks: [Drink] = []
    var ingredients: [Ingredient] = []
    var currentDrinks: [Drink] = []
    var currentIngredients: [Ingredient] = []
    var categories: [DrinkCategory] = []
    var currentCategories: [DrinkCategory] = []
    var selectedIngredient: Ingredient?
    var selectedCategory: DrinkCategory?
    var separatorStyle: UITableViewCell.SeparatorStyle?
    var selectedIndexPath: IndexPath?
    
    let nib = "DrinkSearchTableViewCell"
    
    override func viewDidLoad() {
    
        
        super.viewDidLoad()
        
        // Setup bg
        let image = UIImage(named: "launchscreen.png")!
        self.setBackgroundImage(image, withColor: UIColor.red.withAlphaComponent(0.6))
        
        self.backgroundImageSpeedRatio = 0.2
        self.backgroundImageViewHeight = 800
        
        self.separatorStyle = self.tableView.separatorStyle
        
        self.searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.delegate = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.searchBarStyle = .minimal
            tableView.tableHeaderView = controller.searchBar
            
            let textField : UITextField = controller.searchBar.getViewElement(type: UITextField.self)!
    
            let blurView = textField.addBlurEffect(effect: .regular)
    
            blurView.clipsToBounds = true
            blurView.layer.cornerRadius = 5
            
            return controller
        })()
        
        self.tableView.register(UINib.init(nibName: nib, bundle: nil), forCellReuseIdentifier: nib)
        self.drinks = Model.shared.getDrinks()
        self.ingredients = Model.shared.ingredients
        self.categories = Model.shared.categories

        self.tableView.separatorStyle = .none
        
    }
    
    @objc private func scanBarCode() {
        
        self.performSegue(withIdentifier: Navigation.toBarCodeVC.rawValue, sender: self)
        
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return currentCategories.count
        case 1:
            return currentIngredients.count
        case 2:
            return currentDrinks.count
        case 3:
            return (currentCategories.count + currentIngredients.count + currentDrinks.count) == 0 ? 1 : 0
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: nib, for: indexPath) as! DrinkSearchTableViewCell
        switch indexPath.section {
        case 0:
            let category = currentCategories[indexPath.row]
            cell.setDrink(of: .category, with: category)
        case 1:
            // ingredients
            let ingredient = currentIngredients[indexPath.row]
            cell.setDrink(of: .ingredient, with: ingredient)
        case 2:
            // drinks
            let drink: Drink = currentDrinks[indexPath.row]
            cell.setDrink(of: .drink, with: drink)
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "barCodeCell", for: indexPath)            
            let icon = cell.contentView.viewWithTag(1) as! UIImageView
            icon.tintColor = UIColor(red: 236/255, green: 69/255, blue: 90/255, alpha: 1)
            
            
            return cell
        default:
            return cell
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if currentCategories.count > 0 {
                return "Categories"
            }
            return nil
        case 1:
            if currentIngredients.count > 0 {
                return "Ingredients"
            }
            return nil
            
        case 2:
            if currentDrinks.count > 0 {
                return "Drinks"
            }
            fallthrough
        default:
            return nil
        }
    }
    
    func reloadData() {
        if self.currentDrinks.count == 0 && self.currentIngredients.count == 0 && self.currentCategories.count == 0 {
            self.tableView.separatorStyle = .none
        } else {
            self.tableView.separatorStyle = self.separatorStyle ?? .none
        }
        self.tableView.reloadData()
    }
    
    
    //MARK: Search result updating protocol
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        if searchText == "" {
            self.currentDrinks = []
            self.currentIngredients = []
            self.currentCategories = []
        } else {
            self.currentDrinks = self.drinks.filter { drink in
                return drink.name?.lowercased().contains(searchText.lowercased()) ?? false
            }
            
            self.currentIngredients = self.ingredients.filter { ingredient in
                return ingredient.name?.lowercased().contains(searchText.lowercased()) ?? false
            }
            
            self.currentCategories = self.categories.filter { category in
                return category.name?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
        self.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.currentDrinks = []
        self.currentIngredients = []
        self.currentCategories = []
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        self.reloadData()
    }
    

    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchController.dismiss(animated: false, completion: nil)
        self.selectedIndexPath = indexPath
        switch indexPath.section {
        case 0:
            self.selectedCategory = currentCategories[indexPath.row]
            self.performSegue(withIdentifier: Navigation.toDrinkForIngredientVC.rawValue, sender: self)
        case 1:
            // An Ingredient has been selected
            self.selectedIngredient = currentIngredients[indexPath.row]
            self.performSegue(withIdentifier: Navigation.toDrinkForIngredientVC.rawValue, sender: self)
        case 2:
            self.performSegue(withIdentifier: Navigation.toDrink2VC.rawValue, sender: self)
        case 3:
            self.performSegue(withIdentifier: Navigation.toBarCodeVC.rawValue, sender: self)
        default:
            return
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Navigation.toDrinkForIngredientVC.rawValue:
            let tableVC = segue.destination as! DrinkForIngredientTableViewController
            let currentVC = sender as! SearchTableViewController
            if let indexPath = self.selectedIndexPath {
                switch indexPath.section {
                case 0:
                    tableVC.vcForClass = .category
                    tableVC.category = currentVC.selectedCategory!
                case 1:
                    tableVC.vcForClass = .ingredient
                    tableVC.withIngredient = currentVC.selectedIngredient!
                default:
                    return
                }
            }
        
        case Navigation.toDrink2VC.rawValue:
            let v = segue.destination as! DrinkViewController
            if let index = self.selectedIndexPath {
                v.setDrink(drink: currentDrinks[index.row])
            }
        
        default:
            return
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    override func setDarkMode(enabled: Bool) {
        super.setDarkMode(enabled: enabled)
        if enabled {
            self.searchController.searchBar.barStyle = .black
        } else {
            self.searchController.searchBar.barStyle = .default
        }
    }

}
