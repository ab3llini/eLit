//
//  DrinkTableViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 17/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit
import ViewAnimator

class HomeTableViewController: BlurredBackgroundTableViewController, UINavigationControllerDelegate, UIViewControllerPreviewingDelegate, FSPagerViewDelegate {
    

    let nibs = ["DrinkTableViewCell", "HeaderTableViewCell"]
    
    let selection = UISelectionFeedbackGenerator()
    
    let drinkSectionHeight : CGFloat = 40.0
        
    //Load drinks
    var drinks : [Drink] = []
    var categories : [DrinkCategory] = []
    
    // Storyboard segue
    var segue = Navigation.toDrinkVC


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

    
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        show(viewControllerToCommit, sender: self)
    }
    
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        default:
            return drinks.count
        }
        
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.section) {
            
        case 0:
            
            //Header
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
            
            // Register self as header delegate
            cell.drinkPagerView.delegate = self
            
            return cell
            
            
            
        default:
            
            //Drinks
            let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkTableViewCell", for: indexPath) as! DrinkTableViewCell
            let drink : Drink = drinks[indexPath.row]
            cell.setDrink(drink: drink)
            
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            return
        case 1:
            self.performSegue(withIdentifier: self.segue.rawValue, sender: self)
        default:
            return
        }
        
        
        
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return 0
        default:
            return drinkSectionHeight
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
        switch section {
        case 0:
            
            return nil

        default:
            
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: drinkSectionHeight))
            
            let label = UILabel()
            label.frame = CGRect(x: 20, y: 0, width: tableView.bounds.size.width, height: drinkSectionHeight)
            label.text = "Drinks we love"
            label.textColor = UIColor.darkGray
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)

            view.addSubview(label)
            
            
            return view
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
            
            if let indexPath = tableView.indexPathForSelectedRow{
                
                switch indexPath.section {
                    
                case 0:
                        break;
                case 1:
                        
                        // Get VC
                        let destination : DrinkViewController = segue.destination as! DrinkViewController
                    
                        let selectedDrink = self.drinks[indexPath.row]
                        
                        destination.setDrink(drink: selectedDrink)
                    
                        break;
                default:
                    break;

                }
                
            }
            
        default:
            return
        }
        
     }


}
