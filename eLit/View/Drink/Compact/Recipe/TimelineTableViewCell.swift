//
//  TimelineTableViewCell.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 05/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {

    @IBOutlet weak var timelineView: TimelineView!
    @IBOutlet weak var preparationLabel: AdaptiveLabel!
    @IBOutlet weak var stepLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func resetAfterDeque() {
        self.timelineView.isLastCell = false
        self.timelineView.isFistCell = false
        self.timelineView.setNeedsDisplay()
    }
    
    func set(_ prepString: NSAttributedString) {
        self.preparationLabel.attributedText = prepString
        DarkModeManager.shared.requestUpdateFor(self.preparationLabel)
    }
    
}
