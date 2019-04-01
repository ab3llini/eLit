//
//  TimelineView.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 05/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

@IBDesignable
class TimelineView: UIView {

    @IBInspectable var topMargin : CGFloat = 10
    @IBInspectable var color : UIColor = UIColor.darkGray
    @IBInspectable var lineWidth : CGFloat = 2
    @IBInspectable var radius : CGFloat = 5
    
    var isFistCell = false
    var isLastCell = false
    
    
    override func draw(_ rect: CGRect) {
                
        var path = UIBezierPath()
        let start = CGPoint(x: self.bounds.size.width / 2, y: 0)
        
        if (!isFistCell) {
            
            
            path.move(to: start)
            path.addLine(to: CGPoint(x: start.x, y: topMargin))
            
            self.strokePath(path: path)
            
            path = UIBezierPath()
            
        }
        
        //path.move(to: CGPoint(x: start.x, y: topMargin))
        path.addArc(withCenter: CGPoint(x: start.x, y: topMargin + radius), radius: radius, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 3 / 2, clockwise: true)
        
        self.strokePath(path: path)

        if (!isLastCell) {
            path = UIBezierPath()
            
            path.move(to: CGPoint(x: start.x, y: topMargin + 2 * radius))
            path.addLine(to: CGPoint(x: start.x, y: self.bounds.size.height))
            
            self.strokePath(path: path)
        }
        
    }
    
    private func strokePath(path : UIBezierPath) {
        
        path.close()
        color.set()
        path.lineWidth = lineWidth
        path.stroke()
        
    }
    
    
    

}
