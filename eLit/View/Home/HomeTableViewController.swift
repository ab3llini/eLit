//
//  DrinkTableViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 17/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit
import ViewAnimator



class HomeTableViewController: BlurredBackgroundTableViewController, UINavigationControllerDelegate, UIViewControllerPreviewingDelegate, FSPagerViewDelegate, RGDrinkTableViewCellDelegate {
    

    let nibs = ["CPDrinkTableViewCell", "RGDrinkTableViewCell", "HeaderTableViewCell"]
    
    let selection = UISelectionFeedbackGenerator()
    
    let drinkSectionHeight : CGFloat = 40.0
        
    //Load drinks
    var drinks : [Drink] = []
    var categories : [DrinkCategory] = []
    var categoryWheel : FSPagerView!
    
    // Storyboard segue
    var segue = Navigation.toDrinkVC
    
    var selectedDrink : Drink?

    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        //Load nibs
        for nib in nibs {
            
            self.tableView.register(UINib.init(nibName: nib, bundle: nil), forCellReuseIdentifier: nib)
            
        }
        
        //Register for 3D touch
        registerForPreviewing(with: self, sourceView: self.tableView)
        
        self.drinks = Model.shared.getDrinks()
        self.categories = Model.shared.getCategories()
        
        
        // Remove space between sections.
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        
        // Remove space at top and bottom of tableView.
        tableView.tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: CGFloat.leastNormalMagnitude)))
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: CGFloat.leastNormalMagnitude)))
        
        self.navigationController?.delegate = self
        
        // Assign bg
        if (self.categories.count > 0) {
            self.categories.first!.setImageAndColor(calling: self.setBackgroundImage)
        }
        
    }
    
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        
        self.categories[targetIndex].setImageAndColor { (image, color) in
            self.setBackgroundImage(image, withColor: color)
        }
        
        self.selection.selectionChanged()

        
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
        self.performSegue(withIdentifier: Navigation.toDrinkForIngredientVC.rawValue, sender: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.checkRatingDidChange()
    }

    func checkRatingDidChange() {
        
        if let visibles = self.tableView.indexPathsForVisibleRows {
            
            switch (UIScreen.main.traitCollection.horizontalSizeClass) {
            case .compact:
                for idx in visibles {
                    
                    if idx.section == 1 {
                        
                        let cell : CPDrinkTableViewCell = self.tableView.cellForRow(at: idx) as! CPDrinkTableViewCell
                        
                        cell.ratingView.isHidden = !Preferences.shared.getSwitch(for: .homeRating)
                        
                        self.drinks[idx.row].getRating { (newRating) in
                            
                            if cell.ratingView.rating != newRating {
                                
                                cell.setRating()
                                
                            }
                        }
                        
                    }
                    
                }
            default:
                return
            }
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        show(viewControllerToCommit, sender: self)
    }
    
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        if (UIScreen.main.traitCollection.horizontalSizeClass == .compact) {
        
            let indexPath = tableView.indexPathForRow(at: location)!
            
            switch indexPath.section {
                
                case 0:
                    // Disable 3D touch for PagerView
                    return nil
                default:
                    
                    //This will show the cell clearly and blur the rest of the screen for our peek.
                    previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
                    
                    let destination = storyboard?.instantiateViewController(withIdentifier: "drinkVC") as! DrinkViewController
                    
                    let selectedDrink = self.drinks[indexPath.row]
                    
                    destination.setDrink(drink: selectedDrink)
                    
                    return destination
            }
        }
        else {
            return nil
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        // On iphone, we want to have two sections: header + drinks
        // On iPad we want to have multiple collection views
        switch (UIScreen.main.traitCollection.horizontalSizeClass) {
        case .compact:
            return 2
        case .regular:
            return self.categories.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (UIScreen.main.traitCollection.horizontalSizeClass) {
        case .compact:
            switch section {
            case 0:
                return 1
            default:
                return drinks.count
            }
        case .regular:
            return 1
        default:
            return 0
        }
        
        
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (UIScreen.main.traitCollection.horizontalSizeClass) {
        case .compact:
            switch (indexPath.section) {
                
            case 0:
                
                //Header
                let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
                
                // Register self as header delegate
                cell.categoryWheel.delegate = self
                
                self.categoryWheel = cell.categoryWheel
                
                return cell
                
                
                
            default:
                
                //Drinks
                let cell = tableView.dequeueReusableCell(withIdentifier: "CPDrinkTableViewCell", for: indexPath) as! CPDrinkTableViewCell
                let drink : Drink = drinks[indexPath.row]
                
                cell.setDrink(drink: drink)
                
                return cell
                
            }
        case .regular:
            
            //Collection for current category
            let cell = tableView.dequeueReusableCell(withIdentifier: "RGDrinkTableViewCell", for: indexPath) as! RGDrinkTableViewCell
            let category : DrinkCategory = self.categories[indexPath.section]
            cell.setCategory(category)
            
            cell.delegate = self
            
            return cell
            
        default:
            return UITableViewCell()
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (UIScreen.main.traitCollection.horizontalSizeClass) {
        case .compact:
            switch indexPath.section {
            case 0:
                self.selectedDrink = nil
                return
            case 1:
                
                if let indexPath = tableView.indexPathForSelectedRow {
                    self.selectedDrink = self.drinks[indexPath.row]
                }
            
                self.performSegue(withIdentifier: self.segue.rawValue, sender: self)
            default:
                return
            }
        case .regular:
            return
        default:
            return
        }
        
    }
    
    
    // Protcol for collection view
    func tableCell(_ tableCell: RGDrinkTableViewCell, didSelectDrink drink: Drink, atIndexPath path: IndexPath) {
        
        self.selectedDrink = drink
        
        self.performSegue(withIdentifier: self.segue.rawValue, sender: self)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch (UIScreen.main.traitCollection.horizontalSizeClass) {
        case .compact:
            switch section {
            case 0:
                return 0
            default:
                return drinkSectionHeight
            }
        case .regular:
            return 50
        default:
            return 0
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
     
        switch (UIScreen.main.traitCollection.horizontalSizeClass) {
        case .compact:
            switch section {
            case 0:
                
                return nil
                
            default:
                
                
                let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: drinkSectionHeight))
                
                let label = AdaptiveLabel()
                label.frame = CGRect(x: 20, y: 0, width: tableView.bounds.size.width, height: drinkSectionHeight)
                label.text = "Drinks we love"
                label.preferredColor = UIColor.darkGray
                label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
                
                view.addSubview(label)
                
                
                return view
            }
        case .regular:
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50))
            
            let label = AdaptiveLabel()
            label.frame = CGRect(x: 20, y: 20, width: tableView.bounds.size.width, height: 30)
            label.text = self.categories[section].name
            label.preferredColor = UIColor.darkGray
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            view.addSubview(label)

            
            return view
            
        default:
            return nil
        }
        
    }
    
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
    }
    

    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        
        switch segue.identifier {
            
        case self.segue.rawValue:
            
            if let toDisplay = self.selectedDrink {
                
                // Get VC
                let destination : DrinkViewController = segue.destination as! DrinkViewController
                
                destination.setDrink(drink: toDisplay)
                
            }
            
        case Navigation.toDrinkForIngredientVC.rawValue:
            let destination : DrinkForIngredientTableViewController = segue.destination as! DrinkForIngredientTableViewController
            
            destination.vcForClass = ObjectClass.category
            destination.category = self.categories[self.categoryWheel.currentIndex]
            
            
        default:
            return
        }
        
     }

}
