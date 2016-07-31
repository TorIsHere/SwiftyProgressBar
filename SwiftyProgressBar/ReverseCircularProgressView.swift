//
//  ReverseCircularProgressView.swift
//  SwiftyProgressBar
//
//  Created by Kittikorn Ariyasuk on 7/27/2559 BE.
//  Copyright © 2559 TorIsHere. All rights reserved.
//

import UIKit

public class ReverseCircularProgressView: CircleView {
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
    }
    
    override public init (frame : CGRect) {
        super.init(frame : frame)
        self.commonInit()
    }
    
    
    convenience public init () {
        self.init(frame:CGRect.zero)
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        self.pathLayer = CAShapeLayer(layer: self.layer)
        self.gradientLayer = CAGradientLayer(layer: layer)
        
    }
    
    public func drawCircle(duration:CFAbsoluteTime?) {
        
        self.pathLayer = CAShapeLayer(layer: self.layer)
        self.pathLayer.path = self.path.CGPath
        
        self.pathLayer.fillColor = UIColor.clearColor().CGColor
        self.pathLayer.strokeColor = self.primaryColor.CGColor
        self.pathLayer.lineWidth = self.lineWidth
        self.pathLayer.lineCap = kCALineCapRound
        self.pathLayer.lineJoin = kCALineJoinRound
        
        let drawAnimation:CABasicAnimation = CABasicAnimation()
        drawAnimation.keyPath = "strokeEnd"
        if let duration = duration {
            drawAnimation.duration = duration
        } else {
            drawAnimation.duration = 0.0
        }
        drawAnimation.repeatCount = 1.0
        drawAnimation.fromValue   = 0.0
        drawAnimation.toValue     = 1.0
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        drawAnimation.removedOnCompletion = false
        
        
        self.gradientLayer = CAGradientLayer(layer: layer)
        self.gradientLayer.name = "gradientLayer"
        self.gradientLayer.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        self.gradientLayer.colors = [self.secondaryColor.CGColor,
                                     self.secondaryColor.CGColor,
                                     self.primaryColor.CGColor,
                                     self.primaryColor.CGColor,
                                     self.primaryColor.CGColor]
        self.gradientLayer.startPoint = CGPointMake(0,0.6)
        self.gradientLayer.endPoint = CGPointMake(1,0.4)
        self.layer.addSublayer(gradientLayer)
        gradientLayer.mask = self.pathLayer
        
        CATransaction.setCompletionBlock {
            for layer in self.layer.sublayers! {
                if layer.name?.rangeOfString("gradientLayer") != nil {
                    if layer.name?.rangeOfString("gradientLayer" + String(self.gradientPieceCount)) == nil {
                        layer.removeAllAnimations()
                        layer.removeFromSuperlayer()
                    }
                }
            }
        }
        self.pathLayer.addAnimation(drawAnimation, forKey: "drawCircleAnimation")
        CATransaction.commit()
    }
    
    public func setProgress(toProgress:CGFloat, duration:CFAbsoluteTime) {
        let oldEndAngle:CGFloat = self.endAngle
        self.endAngle = self.startAngle + ((toProgress/100) * 360)
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        self.path.addArcWithCenter(center, radius: radius/2 - lineWidth/2, startAngle: oldEndAngle.degreesToRadians, endAngle: endAngle.degreesToRadians, clockwise: true)
        
        self.drawCircle(duration)
    }
    
    public func erase() {
        for layer in self.layer.sublayers! {
            if layer.name == "gradientLayer" {
                layer.removeAllAnimations()
                layer.removeFromSuperlayer()
            }
        }
        
        if self.pathLayer != nil {
            self.pathLayer.removeFromSuperlayer()
        }
        if self.gradientLayer != nil {
            self.gradientLayer.removeFromSuperlayer()
        }
        
        self.gradientPieceCount = 0
        self.path   = UIBezierPath()
        self.endAngle = self.startAngle
        self.setNeedsDisplay()
    }
    
}
