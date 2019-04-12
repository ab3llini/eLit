//
//  TimeoutLabel.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 12/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

@IBDesignable class TimeoutLabel: ChangingLabel, CAAnimationDelegate {
    
    @IBInspectable var borderWidth : CGFloat = 2
    @IBInspectable var primaryColor : UIColor = .green

    private func createCircleLayer() -> CAShapeLayer {
        let shape = CAShapeLayer()
        let start : CGFloat = -(CGFloat.pi / 2)
        let end : CGFloat = 3 / 2 * CGFloat.pi
        let path = CGMutablePath()
        let radius : CGFloat = (self.frame.size.height / 2)
        let center : CGPoint = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        
        path.addArc(center: center, radius: radius, startAngle: start, endAngle: end, clockwise: false)
        
        shape.path = path
        shape.strokeColor = self.primaryColor.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineWidth = self.borderWidth
        shape.lineCap = .round
        
        return shape
        
    }
    
    private func removeLayer() {
        // Remove any sublayer
        if let layers = self.layer.sublayers {
            for layer in layers {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    public func startTimeout(duration : Int) {
        
        let animStroke = CABasicAnimation(keyPath: "strokeEnd")
        animStroke.fromValue         = 1.0
        animStroke.toValue           = 0.0
        animStroke.duration          = CFTimeInterval(duration)
        animStroke.repeatCount       = 0;
        animStroke.autoreverses      = false
        animStroke.delegate          = self
        
        let shape = self.createCircleLayer()
        
        shape.add(animStroke, forKey: "strokeAnimation")
        
        let strings = Array(0...duration - 1).reversed().map(String.init)
        
        self.layer.addSublayer(shape)
        
        self.text = String(duration)
        self.startChanging(every: 1.0, with: strings, animatingAlpha: false)
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.stopChanging()
        self.removeLayer()
        self.text = ""
    }
    

}
