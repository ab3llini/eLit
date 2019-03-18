//
//  RGDrinkTableViewCell.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 18/03/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

protocol RGDrinkTableViewCellDelegate {
    func tableCell(_ tableCell : RGDrinkTableViewCell, didSelectDrink drink: Drink, atIndexPath path: IndexPath)
}

class RGDrinkTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    

    @IBOutlet weak var categoryCollection: UICollectionView!
    
    var currentCategory : DrinkCategory?
    var drinksForCurrentCategory : [Drink] = []
    var delegate : RGDrinkTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.categoryCollection.dataSource = self
        self.categoryCollection.delegate = self
        self.categoryCollection.register(UINib.init(nibName: "RGDrinkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RGDrinkCollectionViewCell")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let category = self.currentCategory {
            if let drinks = category.withDrinks {
                return drinks.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.categoryCollection.dequeueReusableCell(withReuseIdentifier: "RGDrinkCollectionViewCell", for: indexPath) as! RGDrinkCollectionViewCell
        
        cell.setDrink(drink: self.drinksForCurrentCategory[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (self.delegate != nil) {
            
            self.delegate?.tableCell(self, didSelectDrink: self.drinksForCurrentCategory[indexPath.item], atIndexPath: indexPath)
            
        }
    }

    func setCategory(_ category: DrinkCategory) {
        
        self.currentCategory = category
        self.drinksForCurrentCategory = category.withDrinks?.allObjects as! [Drink]
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
