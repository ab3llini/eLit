//
//  DrinkViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 17/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit


class DrinkViewController: BlurredBackgroundTableViewController, AddReviewDelegate, IngredientsTableViewCellDelegate {
    
    var drink : Drink!
    var rating: Double = 0
    var steps : [RecipeStep] = []
    var components : [Component] = []

    var didPrepareSteps = false
    var RGSelectedComponent : Component?
    
    private let sectionHeaderHeight : CGFloat = 50.0

    
    let cell_nibs = ["DrinkImageTableViewCell", "RatingTableViewCell", "DrinkComponentTableViewCell", "TimelineTableViewCell", "RGDrinkImageTableViewCell", "IngredientsTableViewCell", "StepsTableViewCell"]
    
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
            
            step.setAttributedString(completion: { (string) in
                
                ready[idx] = step
                
                if (computed == steps.count - 1) {
                    self.steps = ready as! [RecipeStep]
                    self.tableView.reloadData()
                }
                
                computed = computed + 1
                
            })
            
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
        switch (UIScreen.main.traitCollection.horizontalSizeClass) {
        case .compact:
            return 4
        case .regular:
            return 3
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
        switch (UIScreen.main.traitCollection.horizontalSizeClass) {
        case .regular:
            

            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50))
            
            let label = AdaptiveLabel()
            label.frame = CGRect(x: 20, y: 20, width: tableView.bounds.size.width, height: 30)
            
            switch section {
            case 1:
                label.text = "Ingredients".uppercased()
            case 2:
                label.text = "How to mix".uppercased()
            default:
                return nil
            }
            
            label.preferredColor = UIColor.gray
            label.textColor = label.preferredColor
            label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
            view.addSubview(label)
            
            
            return view
            
        default:
            return nil
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (UIScreen.main.traitCollection.horizontalSizeClass) {
        case .compact:
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
        default:
            return nil
        }

        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        switch (UIScreen.main.traitCollection.horizontalSizeClass) {
        case .compact:
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
        case .regular:
            switch section {
            case 1:
                fallthrough
            case 2:
                return sectionHeaderHeight
            default:
                return CGFloat.leastNormalMagnitude
            }
        
        default:
            return CGFloat.leastNormalMagnitude
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (UIScreen.main.traitCollection.horizontalSizeClass) {
        case .compact:
            switch section {
                case 0:
                    return 1
                case 1:
                    return 1
                case 2:
                    // Ingredients
                    if (Preferences.shared.getSwitch(for: .hideIngredients)) {
                        return 0
                    }
                    else {
                        return self.components.count
                    }
                case 3:
                // Steps
                    if (Preferences.shared.getSwitch(for: .hideRecipe)) {
                        return 0
                    }
                    else {
                        return self.steps.count
                    }
            default:
                return 0
            }
        case .regular:
            switch section {
            case 1:
                return Int(ceil(Double(self.components.count) / 3.0))
            default:
                return 1
            }
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (UIScreen.main.traitCollection.horizontalSizeClass) {
        case .compact:
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
        case .regular:
            switch indexPath.section {
            case 0:
                let cell : RGDrinkImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RGDrinkImageTableViewCell") as! RGDrinkImageTableViewCell
                
                cell.setDrink(self.drink)
                cell.viewController = self
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showReviewsViewController))
                cell.addGestureRecognizer(tapRecognizer)
                
                return cell
            case 1:
                let cell : IngredientsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTableViewCell") as! IngredientsTableViewCell
                
                cell.delegate = self
                
                let lBound = indexPath.row * 3
                var rBound = indexPath.row * 3 + 2
                let c = self.components.count - 1
                
                if rBound > c{
                    rBound = c
                }
                
                // Set left comp [always exists]
                cell.leftComponent.setComponent(self.components[lBound])
                
                if (lBound + 1 <= rBound) {
                    cell.centerComponent.setComponent(self.components[lBound + 1])
                    
                    if (lBound + 2 <= rBound) {
                        
                        cell.rightComponent.setComponent(self.components[rBound])
                        
                    }
                    
                }
                
                
                return cell
            case 2:
                
                let cell : StepsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StepsTableViewCell") as! StepsTableViewCell
                
                cell.setRecipe(self.drink.drinkRecipe!)
                
                return cell
                
            default:
                return UITableViewCell();
            }
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
            tableVC.vcForClass = .ingredient

            switch (UIScreen.main.traitCollection.horizontalSizeClass) {
            case .compact:
                if let selected = tableView.indexPathForSelectedRow {
                    tableVC.withIngredient = self.components[selected.row].ingredient
                }
                else {
                    print("Can't setup ingredient")
                }
            case .regular:
                
                if let consistentComponent = self.RGSelectedComponent {
                    tableVC.withIngredient = consistentComponent.ingredient
                    self.RGSelectedComponent = nil
                }
                
            default:
                return
            }
            
            
        default: break
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (UIScreen.main.traitCollection.horizontalSizeClass) {
        case .compact:
            switch indexPath.section {
            case 2:
                self.performSegue(withIdentifier: Navigation.toDrinkForIngredientVC.rawValue, sender: self)
            default:
                return
            }
        case .regular:
            return
        default:
            return
        }
    }
    
    // Regular size class delegate
    func ingredientsTableViewCell(_ cell: IngredientsTableViewCell, didSelectComponent component: Component, for view: ComponentView) {
        self.RGSelectedComponent = component
        self.performSegue(withIdentifier: Navigation.toDrinkForIngredientVC.rawValue, sender: self)
    }

}
