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

    @IBInspectable public var primaryColor: UIColor = UIColor.blueColor()
    @IBInspectable public var secondaryColor: UIColor = UIColor.grayColor()
    @IBInspectable public var bgColor: UIColor = UIColor.grayColor()
    @IBInspectable public var lineWidth:CGFloat = 10
    @IBInspectable public var bgLineWidth:CGFloat = 6
    @IBInspectable public var startAngle:CGFloat = -90
    @IBInspectable public var endAngle:CGFloat = 0
    @IBInspectable public var willDraw:Bool = true
    
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
            
            //self.drawCircle()
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
    
    }