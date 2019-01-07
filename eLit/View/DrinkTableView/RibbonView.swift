//
//  RibbonView.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 06/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit

class RibbonView: UIView {
    
    
    @IBOutlet weak var textLabel: UILabel!
    
    let nibName = "RibbonView"
    var contentView: UIView?
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    func setText(value : String) {
        
        self.textLabel.text = value
        
    }
    
    func setColor(color : UIColor) {
        
        self.contentView!.backgroundColor = color
        
    }
    
}
