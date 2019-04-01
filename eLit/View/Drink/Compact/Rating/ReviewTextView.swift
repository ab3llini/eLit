//
//  ReviewTextView.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 14/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

@IBDesignable class ReviewTextView : UITextView, UITextViewDelegate {
    
    var placeholder : UITextField!
    
    override func awakeFromNib() {
        self.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
        
        
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let newAlpha: CGFloat = self.text.isEmpty ? 1 : 0
        if placeholder.alpha != newAlpha {
            UIView.animate(withDuration: 0.3) {
                self.placeholder.alpha = newAlpha
            }
        }
    }
    
}
