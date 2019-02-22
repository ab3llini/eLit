//
//  DrinkViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 17/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit


class DrinkViewController: BlurredBackgroundTableViewController, AddReviewDelegate {
    
    var drink : Drink!
    var rating: Double = 0
    var steps : [RecipeStep] = []
    var components : [Component] = []

    var didPrepareSteps = false
    
    let cell_nibs = ["DrinkImageTableViewCell", "RatingTableViewCell", "DrinkComponentTableViewCell", "TimelineTableViewCell"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        for nib in cell_nibs {
            
            // Register nibs
            self.tableView.register(UINib(nibName: nib, bundle: nil), forCellReuseIdentifier: nib)
            
        }
        
        let steps = drink.drinkRecipe?.steps?.array as? [RecipeStep] ?? []
        var ready = [RecipeStep?](repeating: nil, count: steps.count)
        
        var computed = 0
        
        for (idx, step) in steps.enumerated() {
            
            step.setAttributedString { (string) in
                
                ready[idx] = step
                
                if (computed == steps.count - 1) {
                    self.steps = ready as! [RecipeStep]
                    self.tableView.reloadData()
                }
                
                computed = computed + 1
                
                
            }
            
        }
        
        self.updateRating()
        
    }
    
    func updateRating(reload : Bool = false) {
        
        self.drink.getRating(forceReload: reload) { (rating) in
            self.rating = rating
            self.tableView.reloadRows(at: [IndexPath(indexes: [1, 0])], with: .automatic)
        }
        
    }
    
    // Delegate method
    func didSubmitReview() {
        
        //Sending request for drink rating
        self.updateRating(reload: true)
        
    }
    
    public func setDrink(drink : Drink) {
        
        // Set drink
        self.drink = drink
        
        self.components = self.drink.components()
    
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //Layout content
        self.layoutContent()
                
    }
    
    

    private func layoutContent() {
        
        self.drink.setImageAndColor { (image, color) in
            self.setBackgroundImage(image, withColor: color)
        }
        
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
            return self.components.count
        case 3:
            // Steps
            return self.steps.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        switch indexPath.section {
        case 0:
            
            let cell : DrinkImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DrinkImageTableViewCell") as! DrinkImageTableViewCell
                        
            drink.setImage(to: cell.imageViewContainer)
        
            cell.drinkNameLabel.text = self.drink?.name
            
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
            
            let component = self.components[indexPath.row]
            
            var qty : String
            if component.qty == 0 {
                qty = ""
            } else if floor(component.qty) == component.qty {
                qty = String(format: "%.0f", component.qty)
            } else if (component.qty * 10) == floor(component.qty * 10) {
                qty = String(format: "%.1f", component.qty)
            } else {
                qty = String(format: "%.2f", component.qty)
            }
            
            component.setImage { (image) in
                cell.ingredientImageView.image = image
            }
            
            cell.qtyLabel.text = qty
            cell.unitLabel.text = component.unit.uppercased()
            cell.ingredientLabel.text = component.name
            
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
            
            cell.stepLabel.text = "Step \(indexPath.row + 1)"
            cell.preparationLabel.attributedText = self.steps[indexPath.row].attributedString
            

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
            
            destination.delegates.append(self)
            destination.drink = self.drink

        case Navigation.toDrinkForIngredientVC.rawValue:
            let tableVC = segue.destination as! DrinkForIngredientTableViewController
            
            if let selected = tableView.indexPathForSelectedRow {
                tableVC.vcForClass = .ingredient
                tableVC.withIngredient = self.components[selected.row].ingredient

            }
            else {
                
                print("Can't setup ingredient")
                
            }
            
            
        default: break
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            
            self.performSegue(withIdentifier: Navigation.toDrinkForIngredientVC.rawValue, sender: self)
            
        default:
            return
        }
    }
    

}
