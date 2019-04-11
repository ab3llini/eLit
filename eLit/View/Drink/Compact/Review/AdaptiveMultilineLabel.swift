//
//  AdaptiveMultilineLabel.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 11/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class AdaptiveMultilineLabel: AdaptiveLabel {

    private var collapsedNumberOfLines : Int!
    public var collapsedFrame : CGRect!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collapsedNumberOfLines = self.numberOfLines
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.collapsedFrame == nil {
            self.collapsedFrame = self.bounds
        }
    }
    
    private func expectedLabelHeight() -> CGFloat {
        let myText = self.text! as NSString

        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font], context: nil)
        return min(labelSize.height, 400)
    }
    
    func isTruncated() -> Bool {
        
        let required = Int(ceil(self.expectedLabelHeight() / self.font.lineHeight))
        return required > self.collapsedNumberOfLines
        
    }
    
    func isCollapsed() -> Bool {
        return self.numberOfLines == self.collapsedNumberOfLines
    }
    
    private func resizeToFit(_ height: CGFloat) {
        
        var newFrame = self.frame
        newFrame.size.height = height
        self.frame = newFrame
    }
    
    func toggleCollapse() -> CGFloat {
        
        if self.isCollapsed() {
            self.numberOfLines = 0
            let size = self.expectedLabelHeight()
            self.resizeToFit(size)
            return size
        } else {
            self.numberOfLines = self.collapsedNumberOfLines
            self.resizeToFit(self.collapsedFrame.size.height)
            return self.collapsedFrame.size.height
        }
    }
    
}
