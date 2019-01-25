//
//  HeaderTableViewCell.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 08/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit

protocol HeaderViewProtocol {
    
    func imageDidChange(image : UIImage)
    
}


class HeaderTableViewCell: UITableViewCell, FSPagerViewDataSource {
    
    
    var gradient : CAGradientLayer!
    
    //Load drinks
    var drinks : [Drink] = []
    
    
    @IBOutlet weak var drinkPagerView: FSPagerView! {
        didSet {
            self.drinkPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return drinks.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let image = UIImage(named: drinks[index].image!)
        cell.imageView?.image = image
        cell.textLabel?.text = drinks[index].name
        
        //let bg = Renderer.shared.getCoreColors()[drinks[index].name!]!.withAlphaComponent(0.1)
        //cell.setBlurredImage(to: image!, withBackground: bg)
        
        return cell
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        drinkPagerView.dataSource = self
        
        drinkPagerView.itemSize = CGSize(width: 220, height: 220)
        
        self.drinkPagerView.transformer = FSPagerViewTransformer(type: .linear)
    
        self.drinks = Model.shared.getDrinks()
    
        
    }
    
    override func layoutSubviews() {
        
        guard gradient != nil else {
            
            // Add a gradient at the bottom of the image
            gradient = CAGradientLayer()
            
            gradient.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 0, y: 0)
            gradient.locations = [0, 1]
            gradient.frame = CGRect(x: 0, y: self.bounds.size.height - 100, width: self.bounds.size.width, height: 100)
            
            self.layer.insertSublayer(gradient, at: 0)
            
            return
        }
        
        
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
}
