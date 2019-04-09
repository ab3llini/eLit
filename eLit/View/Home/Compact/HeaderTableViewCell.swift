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
    
    
    @IBOutlet weak var categoryWheel: FSPagerView! {
        didSet {
            self.categoryWheel.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return categories.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        // Clear image and set the default one
        cell.imageView?.image = UIImage(named: "category_placeholder.png")
        
        categories[index].getImage { (image) in
            cell.imageView?.image = image
        }
        
        cell.textLabel?.text = self.categories[index].name
        cell.setNeedsLayout()

        
        return cell
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        categoryWheel.dataSource = self
        
        self.categoryWheel.transformer = FSPagerViewTransformer(type: .linear)
    
        self.categories = Model.shared.getCategories()
    
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = self.bounds.size.height * 0.8
        
        categoryWheel.itemSize = CGSize(width: size, height: size)
        
    }

    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
}
