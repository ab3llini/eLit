//
//  StepsTableViewCell.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 01/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class StepsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var recipe : [RecipeStep] = []
    
    @IBOutlet weak var stepsCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.stepsCollectionView.register(UINib.init(nibName: "StepCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StepCollectionViewCell")
        
        self.stepsCollectionView.delegate = self
        self.stepsCollectionView.dataSource = self
        self.pageControl.currentPage = 0
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        self.pageControl.currentPage = 0
        
        let N = self.recipe.count
        let margins = (N - 1) > 0 ? N - 1 : 0
        let w = self.stepsCollectionView.frame.size.width
        
        let m = max(0, CGFloat(N * 400) + CGFloat(margins * 20) - w) / CGFloat(N)
        
        self.pageControl.currentPage = Int(self.stepsCollectionView.contentOffset.x / m)
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recipe.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.stepsCollectionView.dequeueReusableCell(withReuseIdentifier: "StepCollectionViewCell", for: indexPath) as! StepCollectionViewCell
        
        cell.setStep(self.recipe[indexPath.item], forIndex: indexPath.item)
        
        return cell
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setRecipe(_ recipe : Recipe) {
        self.recipe = recipe.steps!.array as! [RecipeStep]
        self.pageControl.numberOfPages = self.recipe.count

    }
}
