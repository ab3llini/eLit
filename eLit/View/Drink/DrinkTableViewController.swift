//
//  DrinkTableViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 17/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit
import ViewAnimator

class DrinkTableViewController: UITableViewController, UIViewControllerPreviewingDelegate, UINavigationControllerDelegate {


    let nibs = ["DrinkTableViewCell", "HeaderTableViewCell"]
    
    let drinkSectionHeight : CGFloat = 40.0
    
    var needAlphaReset : [UIView] = []
    
    //Load drinks
    var drinks : [Drink] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.drinks = Model.shared.getDrinks()

    }

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
        
        
        //Register as dleegate for nav controller to handle animations
        self.navigationController!.delegate = self
        
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        show(viewControllerToCommit, sender: self)
        
        //present(viewControllerToCommit, animated: true, completion: nil)
        
    }
    
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        
        let path = tableView.indexPathForRow(at: location)!
        
        switch path.section {
            
            case 0:
                // Disable 3D touch for PagerView
                return nil
            default:
                
                //This will show the cell clearly and blur the rest of the screen for our peek.
                previewingContext.sourceRect = tableView.rectForRow(at: path)
                let drinkVC = storyboard?.instantiateViewController(withIdentifier: "drinkVC") as! DrinkViewController
                
                return drinkVC
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
            return cell
            
            
            
        default:
            
            //Drinks
            let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkTableViewCell", for: indexPath) as! DrinkTableViewCell
            let drink : Drink = drinks[indexPath.row]
            let color = Renderer.shared.getCoreColors()[drink.name!]!
            let image = UIImage(named: drink.image!)!
            
            cell.setDrink(drink: drink, withImage: image, andColor: color)
            
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selected = tableView.cellForRow(at: indexPath)
        
        
        var toAnimate = self.tableView.visibleCells(in: 1)
        let idx = toAnimate.index(of: selected!)!
        
        toAnimate.remove(at: idx)
        
        needAlphaReset = toAnimate
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
        
            for cell in toAnimate {
                
                cell.alpha = 0.2
                
            }
            
        }) { (completition) in
            self.performSegue(withIdentifier: Navigation.toDrinkVC.rawValue, sender: self)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        default:
            return "Cocktails we love"
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
            return UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 0))

        default:
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: drinkSectionHeight))

            view.backgroundColor = UIColor.white
            
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
        
        for cell in needAlphaReset {
            cell.alpha = 1
        }
        
        needAlphaReset = []
        
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
