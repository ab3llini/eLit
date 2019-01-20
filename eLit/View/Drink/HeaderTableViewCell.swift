//
//  HeaderTableViewCell.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 08/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell, FSPagerViewDelegate, FSPagerViewDataSource {
    
    
    let drinks = Model.shared.getDrinks()
    
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
        cell.textLabel?.text = drinks[index].description
        
        let bg = Renderer.shared.getCoreColors()[drinks[index].name!]!.withAlphaComponent(0.1)
        
        
        cell.setBlurredImage(to: image!, withBackground: bg)
        
        return cell
    }


    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        drinkPagerView.delegate = self
        drinkPagerView.dataSource = self
        
        self.drinkPagerView.transformer = FSPagerViewTransformer(type: .linear)
    
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
