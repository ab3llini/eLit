//
//  TimeoutLabel.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 12/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

protocol TimeoutLabelDelegate {
    func timeoutDidExpire()
    
}

class TimeoutLabel: CountdownLabel, CAAnimationDelegate, DarkModeBehaviour {
    
    @IBInspectable var borderWidth : CGFloat = 2
    @IBInspectable var primaryColor : UIColor = .green
    
    public var delegate : TimeoutLabelDelegate?
    
    private var animation : CABasicAnimation!
    private var preferredColor : UIColor!
    
    override func awakeFromNib() {
        self.alpha = 0
        self.preferredColor = self.textColor
        DarkModeManager.shared.register(component: self)
    }
    
    private func createCircleLayer() -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        let start : CGFloat = -(CGFloat.pi / 2)
        let end : CGFloat = 3 / 2 * CGFloat.pi
        let path = CGMutablePath()
        let radius : CGFloat = (self.bounds.size.height / 2)
        let center : CGPoint = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)

        path.addArc(center: center, radius: radius, startAngle: start, endAngle: end, clockwise: false)
        
        shape.path = path
        shape.strokeColor = self.primaryColor.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineWidth = self.borderWidth
        shape.lineCap = .round
        shape.frame = self.bounds
        
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
        
        self.removeLayer()
    
        let animStroke = CABasicAnimation(keyPath: "strokeEnd")
        animStroke.fromValue         = 1.0
        animStroke.toValue           = 0.0
        animStroke.duration          = CFTimeInterval(duration)
        animStroke.repeatCount       = 0;
        animStroke.autoreverses      = false
        animStroke.delegate          = self
        animStroke.isRemovedOnCompletion = true
        
        self.animation = animStroke
        
        let shape = self.createCircleLayer()
        
        shape.add(animStroke, forKey: "strokeAnimation")
    
        self.countdown(from: duration, to: 0) {
            if let callback = self.delegate {
                callback.timeoutDidExpire()
            }
        }
        
        self.layer.addSublayer(shape)
        self.alpha = 1
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        }
    }
    
    override func stopChanging() {
        super.stopChanging()
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        }
    }
    
    func setDarkMode(enabled: Bool) {
        self.textColor = enabled ? .white : self.preferredColor
    }
}
