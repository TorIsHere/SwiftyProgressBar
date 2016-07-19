//
//  ProgressView.swift
//  SwiftyProgressBar
//
//  Created by Kittikorn Ariyasuk on 6/11/16.
//  Copyright © 2016 TorIsHere. All rights reserved.
//

import UIKit

@IBDesignable public class CircularProgressView: CircleView {
    
    var circleRadius: CGFloat!
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
        
        self.drawCircle()
    }
    
    override public init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    
    convenience public init () {
        self.init(frame:CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    public func drawCircle() {
        
         let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
         let radius: CGFloat = max(bounds.width, bounds.height)
         self.path.addArcWithCenter(center, radius: radius/2 - lineWidth/2, startAngle: CGFloat(0 * M_PI / 180), endAngle: CGFloat(90.0 * M_PI / 180), clockwise: true)
 
        
        self.pathLayer = CAShapeLayer(layer: self.layer)
        self.pathLayer.path = self.path.CGPath
        
        self.pathLayer.fillColor = UIColor.clearColor().CGColor
        self.pathLayer.strokeColor = self.primaryColor.CGColor
        self.pathLayer.lineWidth = self.lineWidth
        self.pathLayer.lineCap = kCALineCapRound
        self.pathLayer.lineJoin = kCALineJoinRound
        
        let drawAnimation:CABasicAnimation = CABasicAnimation()
        drawAnimation.keyPath = "strokeEnd"
        drawAnimation.duration            = 0.5
        drawAnimation.repeatCount         = 1.0
        drawAnimation.removedOnCompletion = true
        drawAnimation.fromValue = 0.0
        drawAnimation.toValue   = 1.0
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        
        let gradientLayer:CAGradientLayer = CAGradientLayer(layer: layer)
        gradientLayer.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        print(self.frame)
        let context = UIGraphicsGetCurrentContext()
        gradientLayer.colors = [self.secondaryColor.CGColor,
                                self.secondaryColor.CGColor,
                                self.primaryColor.CGColor,
                                self.primaryColor.CGColor,
                                self.primaryColor.CGColor]
        gradientLayer.startPoint = CGPointMake(0,0.6)
        gradientLayer.endPoint = CGPointMake(1,0.4)
        
        
        self.layer.addSublayer(gradientLayer)
        gradientLayer.mask = self.pathLayer
        
        self.pathLayer.addAnimation(drawAnimation, forKey: "drawCircleAnimation")
    }

    
    public func animate(toProgress:CGFloat, duration:CFAbsoluteTime) {
      
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        let targetEndAngle:CGFloat = ((toProgress/100) * 360) - 90
        
        self.pathLayer = CAShapeLayer(layer: self.layer)
        self.pathLayer.path =  UIBezierPath(arcCenter: center,
            radius: radius/2 - lineWidth/2,
            startAngle: self.startAngle.degreesToRadians,
            endAngle: targetEndAngle.degreesToRadians,
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
