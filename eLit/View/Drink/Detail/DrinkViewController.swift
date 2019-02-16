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
    var rating: Double = 0
    var steps : [RecipeStep]!

    
    let cell_nibs = ["DrinkImageTableViewCell", "RatingTableViewCell", "DrinkComponentTableViewCell", "TimelineTableViewCell"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Sending request for drink rating
        DataBaseManager.shared.requestRating(for: self.drink, completion: { data in
            if (data["status"] as! String) == "ok" {
                let ratingData = data["data"] as! [String: Any]
                self.rating = Double(ratingData["rating"] as? String ?? "0.0") ?? 0.0
                self.tableView.reloadRows(at: [IndexPath(indexes: [1, 0])], with: .automatic)
            }
        })
        
        
        for nib in cell_nibs {
            
            // Register nibs
            self.tableView.register(UINib(nibName: nib, bundle: nil), forCellReuseIdentifier: nib)
            
        }
        
        print(drink.ingredients())

    }
    
    
    
    public func setDrink(drink : Drink) {
        
        // Set drink
        self.drink = drink
        
        // Load steps
        self.steps = drink.drinkRecipe?.steps?.array as? [RecipeStep] ?? []
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //Layout content
        self.layoutContent()
                
    }

    private func layoutContent() {
        
        self.setBackgroundImage(drink.image, withColor: Renderer.shared.getDrinkCoreColors()[self.drink.name!]!)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.drink.ingredients().count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Rating"
        case 2:
            return "Ingredients"
        case 3:
            return "How to mix"
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
            return drink.drinkRecipe?.steps?.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
            let cell : DrinkImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DrinkImageTableViewCell") as! DrinkImageTableViewCell
            
            cell.imageViewContainer.image = drink.image
            cell.drinkNameLabel.text = self.drink.name
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingTableViewCell") as! RatingTableViewCell
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showReviewsViewController))
            
            cell.addGestureRecognizer(tapRecognizer)
            
            cell.ratingLabel.text = String(format: "%.1f", self.rating)
            cell.ratingStars.rating = self.rating
            cell.viewController = self
            
            return cell
            
        case 2:
            
            let cell : DrinkComponentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DrinkComponentTableViewCell") as! DrinkComponentTableViewCell
            
            let ingredient = self.drink.ingredients()[indexPath.row]
            
            cell.ingredientImageView.image = ingredient.image
            cell.ingredientLabel.text = ingredient.name
            
            return cell
            
        case 3:
            
            // Steps
            let cell : TimelineTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell") as! TimelineTableViewCell
            
            cell.resetAfterDeque()

            if (indexPath.row == 0) {
                
                cell.timelineView.isFistCell = true
                
            }
            
            if (indexPath.row == self.steps.count - 1) {
                
                cell.timelineView.isLastCell = true
                
            }
            
            // FIXME
            cell.stepLabel.text = "Step \(indexPath.row + 1)"
            cell.preparationLabel.text = self.steps[indexPath.row].stepDescription
            
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
            
        case Navigation.toAddReviewVC.rawValue:
            
            let destination : AddReviewViewController = segue.destination as! AddReviewViewController
            
            destination.drink = self.drink

            
        default: break
            
        }
        
    }
}
