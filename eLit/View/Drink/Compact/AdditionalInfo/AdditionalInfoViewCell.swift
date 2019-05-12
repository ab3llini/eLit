//
//  AdditionalInfoViewCell.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 12/05/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class AdditionalInfoViewCell: UITableViewCell {

    @IBOutlet weak var descriptionlabel: AdaptiveLabel!
    @IBOutlet weak var volumeLabel: AdaptiveLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
