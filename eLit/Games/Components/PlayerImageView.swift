//
//  PlayerImageView.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 12/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

@IBDesignable
class PlayerImageView: UIView {

    @IBInspectable var steps : Int = 5
    @IBInspectable var borderWidth : CGFloat = 5
    @IBInspectable var primaryColor : UIColor = .green
    @IBInspectable var secondaryColor : UIColor = .red
    
    @IBOutlet weak var imageView : UIImageView!
    
    private var addedLayers : [CAShapeLayer] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.roundImage(with: 1, ofColor: .white)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private var stepAngle : CGFloat {
        return 2 * CGFloat.pi / CGFloat(self.steps)
    }
    
    private var interMargin : CGFloat = 0.4
    
    private func createStepLayer(at index : Int, success : Bool) -> CAShapeLayer {
        let shape = CAShapeLayer()
        let start : CGFloat = -(CGFloat.pi / 2) + CGFloat(index) * self.stepAngle + (interMargin / 2)
        let end : CGFloat = start + self.stepAngle - (interMargin / 2)
        let path = CGMutablePath()
        let radius : CGFloat = (self.frame.size.height / 2) + self.borderWidth
        let center : CGPoint = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        
        path.addArc(center: center, radius: radius, startAngle: start, endAngle: end, clockwise: false)
        
        shape.path = path
        shape.strokeColor = success ? primaryColor.cgColor : secondaryColor.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineWidth = self.borderWidth
        shape.lineCap = .round
        
        return shape
        
    }
    
    override func prepareForInterfaceBuilder() {
        self.layer.addSublayer(self.createStepLayer(at: 0, success: true))
        self.layer.addSublayer(self.createStepLayer(at: 1, success: false))
        self.layer.addSublayer(self.createStepLayer(at: 2, success: true))
        self.layer.addSublayer(self.createStepLayer(at: 3, success: true))
        self.layer.addSublayer(self.createStepLayer(at: 4, success: false))

    }
    
    func clearView () {
        self.imageView.image = nil
   
        for layer in self.addedLayers {
            layer.removeFromSuperlayer()
        }
    }
    
    func addNewArc(at index : Int, success : Bool) {
        
        let new = self.createStepLayer(at: index, success: success)
        self.addedLayers.append(new)
        self.layer.addSublayer(new)
    }
    
    func setImage(to image : UIImage) {
        self.imageView.image = image
    }

}
