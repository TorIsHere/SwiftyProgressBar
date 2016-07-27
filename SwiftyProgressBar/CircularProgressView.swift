//
//  ProgressView.swift
//  SwiftyProgressBar
//
//  Created by Kittikorn Ariyasuk on 6/11/16.
//  Copyright © 2016 TorIsHere. All rights reserved.
//

import UIKit

@IBDesignable
public class CircularProgressView: CircleView {
    
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
        self.erase()
        
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
        
        
        self.gradientLayer = CAGradientLayer(layer: layer)
        self.gradientLayer.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        self.gradientLayer.colors = [self.secondaryColor.CGColor,
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

    public func setProgress(toProgress:CGFloat, duration:CFAbsoluteTime) {
        let oldEndAngle:CGFloat = self.endAngle
        self.endAngle = self.startAngle + ((toProgress/100) * 360)
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        self.path.addArcWithCenter(center, radius: radius/2 - lineWidth/2, startAngle: oldEndAngle.degreesToRadians, endAngle: endAngle.degreesToRadians, clockwise: true)
        /*self.path = UIBezierPath(arcCenter: center,
                                 radius: radius/2 - lineWidth/2,
                                 startAngle: self.startAngle.degreesToRadians,
                                 endAngle: self.endAngle.degreesToRadians,
                                 clockwise: true)*/
        self.drawCircle()
    }
    
    public func erase() {
        if self.pathLayer != nil {
           // self.pathLayer.removeFromSuperlayer()
        }
        if self.gradientLayer != nil {
          //  self.gradientLayer.removeFromSuperlayer()
        }
        
        //self.path   = nil;
        //self.path   = UIBezierPath()
        //self.setNeedsDisplay()
    }
    
}
