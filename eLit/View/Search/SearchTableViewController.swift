//
//  SearchTableViewController.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 24/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import BarcodeScanner


class SearchTableViewController: BlurredBackgroundTableViewController, UISearchResultsUpdating, UISearchBarDelegate, BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate {
    
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
    
    var barCodeViewController = BarCodeViewController()
    
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
        
        self.barCodeViewController.codeDelegate = self
        self.barCodeViewController.dismissalDelegate = self
        
        // DarkMode
        self.setDarkMode(enabled: Preferences.shared.getSwitch(for: .darkMode))
        DarkModeManager.shared.register(component: self)
        
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
        let searchEntries = searchText.lowercased().split(separator: " ").filter{$0.count > 2}
        if searchText == "" {
            self.currentDrinks = []
            self.currentIngredients = []
            self.currentCategories = []
        } else {
            self.currentIngredients = self.ingredients.filter { ingredient in
                var condition = false
                for entry in searchEntries {
                    condition = condition || ingredient.name?.lowercased().contains(String(entry)) ?? false
                }
                return condition
            }
            
            self.currentDrinks = self.drinks.filter { drink in
                var condition = false
                // Check for name
                for entry in searchEntries {
                    condition = condition || drink.name?.lowercased().contains(String(entry)) ?? false
                }
                // Check for ingredients in drink
                for ingredient in drink.ingredients() {
                    condition = condition || self.currentIngredients.contains(ingredient)
                }
                return condition
            }
            
            self.currentCategories = self.categories.filter { category in
                var condition = false
                for entry in searchEntries {
                    condition = condition || category.name?.lowercased().contains(String(entry)) ?? false
                }
                return condition
            }
        }
        self.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
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
            self.present(self.barCodeViewController, animated: true, completion: nil)
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
            self.searchController.searchBar.keyboardAppearance = .dark
        } else {
            self.searchController.searchBar.barStyle = .default
            self.searchController.searchBar.keyboardAppearance = .default
        }
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        
        if (Int(code) != nil) {
            
            DataBaseManager.shared.searchIngredient(for: code) { (result) in
                
                
                self.barCodeViewController.dismiss(animated: true, completion: {
                    
                    self.barCodeViewController.reset()

                    
                    if (result == nil) {
                        
                        let alert = UIAlertController(title: "Product not found", message: "We were unable to find a product for the scanned barcode.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                    else {
                        self.searchController.searchBar.text = result!
                        self.updateSearchResults(for: self.searchController)
                    }
                })
            }
        }
        else {
            self.barCodeViewController.dismiss(animated: true, completion: {
                self.barCodeViewController.reset()
            })
        }
        
        
        
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        
        self.barCodeViewController.dismiss(animated: true, completion: {
            self.barCodeViewController.reset()

        })
        
    }
    

}
