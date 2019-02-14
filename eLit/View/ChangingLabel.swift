//
//  ChangingLable.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 13/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

class ChangingLabel: UILabel {
    
    var textList: [String] = []
    private var displayTime: Double = 0.0
    private var timer: Timer?
    private var textHasToChange: Bool = false
    
    private var currentIndex: Int = 0

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @objc
    private func changeText() {
        
        UIView.animate(withDuration: 0.4) {
            self.alpha = 0
        }
        
        self.text = textList[currentIndex]
        
        UIView.animate(withDuration: 0.4) {
            self.alpha = 1
        }
        self.currentIndex = (self.currentIndex + 1) % (textList.count)
    }
    
    func startChanging(every seconds: Double, with strings: [String]?) {
        guard seconds > 0 else {
            self.textHasToChange = false
            return
        }
        
        if self.timer?.isValid ?? true {
            self.timer?.invalidate()
        }
        
        self.textList = strings ?? self.textList
        self.textHasToChange = true
        self.currentIndex = 0
        self.displayTime = seconds
        self.timer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(self.changeText), userInfo: nil, repeats: true)
    }
    
    func startChanging(every seconds: Double) {
        self.startChanging(every: seconds, with: nil)
    }
    
    func stopChanging() {
        self.timer?.invalidate()
        self.textHasToChange = false
    }

}
