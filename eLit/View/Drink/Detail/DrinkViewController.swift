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
    
    let cell_nibs = ["DrinkImageTableViewCell", "RatingTableViewCell", "DrinkComponentTableViewCell", "TimelineTableViewCell"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        for nib in cell_nibs {
            
            // Register nibs
            self.tableView.register(UINib(nibName: nib, bundle: nil), forCellReuseIdentifier: nib)
            
        }

    }
    
    
    
    public func setDrink(drink : Drink) {
        
        // Set drink
        self.drink = drink
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //Layout content
        self.layoutContent()
                
    }

    private func layoutContent() {
        
        self.setBackgroundImage(UIImage(named: self.drink.image!)!, withColor: Renderer.shared.getCoreColors()[self.drink.name!]!)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Rating"
        case 2:
            return "Ingredients"
        case 3:
            return "Preparation"
        default:
            return nil
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        switch section {
            case 1:
                fallthrough
            case 2:
                fallthrough
            case 3:
                return UITableView.automaticDimension
            default:
                return CGFloat.leastNormalMagnitude

        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            // Ingredients
            return 3
        case 3:
            // Steps
            return 10
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
            let cell : DrinkImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DrinkImageTableViewCell") as! DrinkImageTableViewCell
            
            cell.imageViewContainer.image = UIImage(named: self.drink.image!)!
            cell.drinkNameLabel.text = self.drink.name
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingTableViewCell") as! RatingTableViewCell
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showReviewsViewController))
            
            cell.addGestureRecognizer(tapRecognizer)
            
            //Sending request for drink rating
            DataBaseManager.shared.requestRating(for: self.drink, completion: { data in
                if (data["status"] as! String) == "ok" {
                    let ratingData = data["data"] as! [String: Any]
                    let rating = Double(ratingData["rating"] as? String ?? "0.0") ?? 0.0
                    DispatchQueue.main.async {
                        cell.ratingLabel.text = String(format: "%.1f", rating)
                        cell.ratingStars.rating = rating
                    }
                }
            })
            
            return cell
            
        case 2:
            
            let cell : DrinkComponentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DrinkComponentTableViewCell") as! DrinkComponentTableViewCell
            
            cell.rounded(radius: 10, withBorder: 1, withBorderColor: .green)
            
            return cell
            
        case 3:
            
            // Steps
            let cell : TimelineTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell") as! TimelineTableViewCell
            
            cell.resetAfterDeque()

            if (indexPath.row == 0) {
                
                cell.timelineView.isFistCell = true
                
            }
            
            if (indexPath.row == 9) {
                
                cell.timelineView.isLastCell = true
                
            }
            
            cell.preparationLabel.text = Model.randomString(length: Int.random(in: 10...300))
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    @objc func showReviewsViewController() {
        
        performSegue(withIdentifier: Navigation.toReviewsVC.rawValue, sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case Navigation.toReviewsVC.rawValue:
            
            let destination : ReviewTableViewController = segue.destination as! ReviewTableViewController
            
            destination.drink = self.drink
            
        default: break
            
        }
        
    }
}
