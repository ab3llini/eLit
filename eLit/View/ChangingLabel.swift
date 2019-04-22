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
    private var animateAlpha : Bool = true
    internal var currentIndex: Int = 0
    
    
    @objc
    internal func changeText() {
        
        if (self.animateAlpha) {
            UIView.animate(withDuration: 0.2) {
                self.alpha = 0
            }
        }
        
        self.text = textList[currentIndex]
        
        if (self.animateAlpha) {
            UIView.animate(withDuration: 0.2) {
                self.alpha = 1
            }
        }
        
        self.currentIndex = (self.currentIndex + 1) % (textList.count)
    }
    
    func startChanging(every seconds: Double, with strings: [String]?, animatingAlpha : Bool = true) {
        guard seconds > 0 else {
            self.textHasToChange = false
            return
        }
        
        if self.timer?.isValid ?? true {
            self.timer?.invalidate()
        }
        
        self.animateAlpha = animatingAlpha
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

class CountdownLabel : ChangingLabel {
    
    private var completionBlock : (() -> Void)?
    
    func countdown(from : Int, to: Int, completion : (() -> Void)?) {
        
        let values = Array(to...from - 1).reversed().map(String.init)
        self.text = String(from)
        self.startChanging(every: 1.0, with: values, animatingAlpha: false)
        self.completionBlock = completion
    }
    
    @objc
    override func changeText() {
        super.changeText()
        if self.currentIndex == self.textList.count - 1 {
            self.stopChanging()
            if let block = self.completionBlock {
                block()
            }
        }
    }
    
}
