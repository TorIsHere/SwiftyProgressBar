//
//  CircleView.swift
//  SwiftyProgressBar
//
//  Created by Kittikorn Ariyasuk on 6/11/16.
//  Copyright © 2016 TorIsHere. All rights reserved.
//

import UIKit

let π:CGFloat = CGFloat(M_PI)

extension CGFloat {
    var doubleValue:      Double  { return Double(self) }
    var degreesToRadians: CGFloat { return CGFloat(doubleValue * M_PI / 180) }
    var radiansToDegrees: CGFloat { return CGFloat(doubleValue * 180 / M_PI) }
}

@IBDesignable public class CircleView: UIView {

    @IBInspectable var primaryColor: UIColor = UIColor.blueColor()
    @IBInspectable var secondaryColor: UIColor = UIColor.grayColor()
    @IBInspectable var bgColor: UIColor = UIColor.grayColor()
    @IBInspectable var lineWidth:CGFloat = 10
    @IBInspectable var bgLineWidth:CGFloat = 6
    @IBInspectable var startAngle:CGFloat = -90
    @IBInspectable var endAngle:CGFloat = 0
    @IBInspectable var willDraw:Bool = true
    
    var pathLayer:CAShapeLayer!
    var path:UIBezierPath!
    var bgPath:UIBezierPath!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        path = UIBezierPath(arcCenter: center,
                            radius: radius/2 - lineWidth/2,
                            startAngle: self.startAngle.degreesToRadians,
                            endAngle: self.endAngle.degreesToRadians,
                            clockwise: true)
        
        path.lineWidth = lineWidth
        path.lineCapStyle = CGLineCap.Round
            
        bgPath = UIBezierPath(arcCenter: center,
                              radius: radius/2 - lineWidth/2,
                              startAngle: -90,
                              endAngle: 90,
                              clockwise: true)
        bgPath.lineWidth = bgLineWidth
        
        if willDraw {
            bgColor.setStroke()
            bgPath.stroke()
            
            self.drawCircle()
        }
        
        
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
    
    func drawCircle() {
        /*
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        self.path.addArcWithCenter(center, radius: radius/2 - lineWidth/2, startAngle: 0.0, endAngle: CGFloat(90.0 * M_PI / 180), clockwise: true)
        */
        
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
}