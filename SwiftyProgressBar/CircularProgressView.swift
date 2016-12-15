//
//  ProgressView.swift
//  SwiftyProgressBar
//
//  Created by Kittikorn Ariyasuk on 6/11/16.
//  Copyright © 2016 TorIsHere. All rights reserved.
//

import UIKit

@IBDesignable
open class CircularProgressView: CircleView {
    
    var gradientPieceCount:Int = 0
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override open func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
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
    
    open func drawCircle(_ duration:CFAbsoluteTime?) {
        
        self.pathLayer = CAShapeLayer(layer: self.layer)
        self.pathLayer.path = self.path.cgPath
        
        self.pathLayer.fillColor = UIColor.clear.cgColor
        self.pathLayer.strokeColor = self.primaryColor.cgColor
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
        drawAnimation.isRemovedOnCompletion = false
        
        
        self.gradientLayer = CAGradientLayer(layer: layer)
        self.gradientPieceCount = self.gradientPieceCount + 1
        self.gradientLayer.name = "gradientLayer" + String(self.gradientPieceCount)
        self.gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.gradientLayer.colors = [self.secondaryColor.cgColor,
                                self.secondaryColor.cgColor,
                                self.primaryColor.cgColor,
                                self.primaryColor.cgColor,
                                self.primaryColor.cgColor]
        self.gradientLayer.startPoint = CGPoint(x: 0,y: 0.6)
        self.gradientLayer.endPoint = CGPoint(x: 1,y: 0.4)
        
        
        self.layer.addSublayer(gradientLayer)
        self.gradientLayer.mask = self.pathLayer
        
        CATransaction.setCompletionBlock { 
            for layer in self.layer.sublayers! {
                if layer.name?.range(of: "gradientLayer") != nil {
                    if layer.name?.range(of: "gradientLayer" + String(self.gradientPieceCount)) == nil {
                        layer.removeAllAnimations()
                        layer.removeFromSuperlayer()
                    }
                }
            }
        }
        self.pathLayer.add(drawAnimation, forKey: "drawCircleAnimation")
        CATransaction.commit()
    }

    open func setProgress(_ toProgress:CGFloat, duration:CFAbsoluteTime?) {
        
        
        let oldEndAngle:CGFloat = self.endAngle
        self.endAngle = self.startAngle + ((toProgress/100) * 360)
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        self.path.addArc(withCenter: center, radius: radius/2 - lineWidth/2, startAngle: oldEndAngle.degreesToRadians, endAngle: endAngle.degreesToRadians, clockwise: true)
        
        self.drawCircle(duration)
    }
    
    open func erase() {
        for layer in self.layer.sublayers! {
            if layer.name?.range(of: "gradientLayer") != nil {
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
