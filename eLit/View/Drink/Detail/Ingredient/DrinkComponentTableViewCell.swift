//
//  DrinkComponentTableViewCell.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 05/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class DrinkComponentTableViewCell: UITableViewCell {
    @IBOutlet weak var ingredientImageView: UIImageView!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var componentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func rounded(radius: CGFloat?, withBorder border: CGFloat, withBorderColor borderColor: UIColor) {
        self.componentView.layer.borderWidth = border
        self.componentView.layer.borderColor = borderColor.cgColor
        guard let r = radius else {
            self.componentView.layer.cornerRadius = self.componentView.frame.height / 2
            return
        }
        
        self.componentView.layer.cornerRadius = r
    }
    
}
