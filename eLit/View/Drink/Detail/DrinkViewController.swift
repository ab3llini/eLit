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
    
    let cell_nibs = ["DrinkImageTableViewCell"]
    let header_footer_nibs = ["RatingHeaderFooterView"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        for nib in cell_nibs {
            
            // Register nibs
            self.tableView.register(UINib(nibName: nib, bundle: nil), forCellReuseIdentifier: nib)
            
        }
        for nib in header_footer_nibs {
            
            self.tableView.register(UINib(nibName: nib, bundle: nil), forHeaderFooterViewReuseIdentifier: nib)
            
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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat.leastNormalMagnitude
        default:
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            let ratingView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RatingHeaderFooterView") as! RatingHeaderFooterView
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showReviewsViewController))
            
            ratingView.addGestureRecognizer(tapRecognizer)
            
            ratingView.ratingLabel.text = "0.0"
            ratingView.ratingStars.rating = 0.0
            
            //Sending request for drink rating
            DataBaseManager.shared.requestRating(for: self.drink, completion: { data in
                if (data["status"] as! String) == "ok" {
                    let ratingData = data["data"] as! [String: Any]
                    var rating = Double(ratingData["rating"] as? String ?? "0.0") ?? 0.0
                    rating = (rating * 10).rounded()/10
                    DispatchQueue.main.async {
                        ratingView.ratingLabel.text = String(rating)
                        ratingView.ratingStars.rating = rating
                    }
                }
            })
            
            return ratingView
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
            let cell : DrinkImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DrinkImageTableViewCell") as! DrinkImageTableViewCell
            
            cell.imageViewContainer.image = UIImage(named: self.drink.image!)!
            cell.drinkNameLabel.text = self.drink.name
            
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
