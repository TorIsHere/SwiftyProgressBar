//
//  ProgressView.swift
//  TorProgressBar
//
//  Created by Kittikorn Ariyasuk on 6/11/16.
//  Copyright © 2016 TorIsHere. All rights reserved.
//

import UIKit

@IBDesignable public class ProgressView: CircleView {
    
    var circleRadius: CGFloat!
    var pathLayer:CAShapeLayer!
    var progress: CGFloat {
        get {
            return pathLayer.strokeEnd
        }
        set(newValue) {
            if (newValue > 1) {
                pathLayer.strokeEnd = 1
            } else if (newValue < 0) {
                pathLayer.strokeEnd = 0
            } else {
                pathLayer.strokeEnd = newValue
            }
        }
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
    }
    
    
    required public init(coder aDecoder: NSCoder) {
    
    }
    
    public func animate(toProgress:CGFloat, duration:CFAbsoluteTime) {
      
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        let endAngle:CGFloat = ((toProgress/100) * 360) - 90
        
        self.pathLayer = CAShapeLayer(layer: self.layer)
        self.pathLayer.path =  UIBezierPath(arcCenter: center,
            radius: radius/2 - lineWidth/2,
            startAngle: self.startAngle.degreesToRadians,
            endAngle: endAngle.degreesToRadians,
            clockwise: true).CGPath
    
        
        self.pathLayer.strokeColor = self.primaryColor.CGColor
        self.pathLayer.lineWidth = self.lineWidth
        self.pathLayer.fillColor = UIColor.clearColor().CGColor
        
        self.pathLayer.lineJoin = kCALineJoinRound
        
        pathLayer.removeFromSuperlayer()
        self.layer.addSublayer(self.pathLayer)
        
        let drawAnimation:CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration            = duration
        drawAnimation.repeatCount         = 1.0
        
        drawAnimation.fromValue = NSNumber(float: 0.0)
        drawAnimation.toValue   = NSNumber(float: 1.0)
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    
        pathLayer.addAnimation(drawAnimation, forKey: "drawCircleAnimation")
        
    }
    
    public func erase() {
        self.path   = nil;
        self.path   = UIBezierPath()
        self.setNeedsDisplay()
    }
    
}
