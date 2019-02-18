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
    
        
    //Load categories
    var categories : [DrinkCategory]!
    
    
    @IBOutlet weak var drinkPagerView: FSPagerView! {
        didSet {
            self.drinkPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return categories.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        categories[index].setImage { (image) in
            cell.imageView?.image = image
            cell.setNeedsDisplay()

        }
        
        cell.textLabel?.text = categories[index].name
    
        
        return cell
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        drinkPagerView.dataSource = self
        
        drinkPagerView.itemSize = CGSize(width: 220, height: 220)
        
        self.drinkPagerView.transformer = FSPagerViewTransformer(type: .linear)
    
        self.categories = Model.shared.getCategories()
    
        
    }

    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
}
