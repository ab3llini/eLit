//
//  SearchTableViewController.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 24/01/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class SearchTableViewController: BlurredBackgroundTableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    var drinks: [Drink] = []
    var ingredients: [Ingredient] = []
    var currentDrinks: [Drink] = []
    var currentIngredients: [Ingredient] = []
    var selectedIngredient: Ingredient? = nil
    var separatorStyle: UITableViewCell.SeparatorStyle?
    
    var searchText: String?
        
    let nib = "DrinkSearchTableViewCell"

    
    override func viewDidLoad() {
    
        
        super.viewDidLoad()
        
        // Setup bg
        let image = UIImage(named: "Drink3")!
        self.setBackgroundImage(image, withColor: UIColor.blue.withAlphaComponent(0.6))
        
        self.backgroundImageSpeedRatio = 0.2
        self.backgroundImageViewHeight = 800
        
        self.separatorStyle = self.tableView.separatorStyle
        
        self.setupSearchBar()
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        
        self.tableView.register(UINib.init(nibName: nib, bundle: nil), forCellReuseIdentifier: nib)
        self.drinks = Model.shared.getDrinks()
        self.ingredients = EntityManager.shared.fetchAll(type: Ingredient.self) ?? []

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return currentIngredients.count
        case 1:
            return currentDrinks.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: nib, for: indexPath) as! DrinkSearchTableViewCell
        switch indexPath.section {
        case 0:
            // ingredients
            let ingredient = currentIngredients[indexPath.row]
            cell.setDrink(of: .ingredient, with: ingredient)
        case 1:
            // drinks
            let drink: Drink = currentDrinks[indexPath.row]
            cell.setDrink(of: .drink, with: drink)
        default:
            return cell
        }
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if currentIngredients.count > 0 {
                return "Ingredients"
            }
            return nil
            
        case 1:
            if currentDrinks.count > 0 {
                return "Drinks"
            }
            fallthrough
        default:
            return nil
        }
    }
    
    func reloadData() {
        if self.currentDrinks.count == 0 && self.currentIngredients.count == 0{
            self.tableView.separatorStyle = .none
        } else {
            self.tableView.separatorStyle = self.separatorStyle ?? .none
        }
        self.tableView.reloadData()
    }
    
    
    //MARK: Search result updating protocol
    func updateSearchResults(for searchController: UISearchController) {
        return
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.currentDrinks = []
            self.currentIngredients = []
            self.searchText = nil
        } else {
            self.currentDrinks = self.drinks.filter { drink in
                return drink.name?.lowercased().contains(searchText.lowercased()) ?? false
            }
            
            self.currentIngredients = self.ingredients.filter { ingredient in
                return ingredient.name?.lowercased().contains(searchText.lowercased()) ?? false
            }
            self.searchText = searchText
        }
        self.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.currentDrinks = []
        self.currentIngredients = []
        self.searchText = nil
        self.reloadData()
    }
    
    func setupSearchBar() {
        
        let searchBar = self.searchController.searchBar
        
        searchBar.searchBarStyle = .minimal
        
        let textField : UITextField = searchBar.getViewElement(type: UITextField.self)!
        
        //textField.backgroundColor = .darkGray
        let blurView = textField.addBlurEffect(effect: .regular)
        
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = 5
    }
    

    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            // An Ingredient has been selected
            self.selectedIngredient = currentIngredients[indexPath.row]
            self.performSegue(withIdentifier: Navigation.toDrinkForIngredientVC.rawValue, sender: self)
        case 1:
            self.performSegue(withIdentifier: Navigation.toDrink2VC.rawValue, sender: self)
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
            tableVC.withIngredient = currentVC.selectedIngredient!
        
        case Navigation.toDrink2VC.rawValue:
            let v = segue.destination as! DrinkViewController
            if let index = self.tableView.indexPathForSelectedRow {
                v.setDrink(drink: drinks[index.row])
            }
        
        default:
            return
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
