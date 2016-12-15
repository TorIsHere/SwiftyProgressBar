//
//  CircleView.swift
//  SwiftyProgressBar
//
//  Created by Kittikorn Ariyasuk on 6/11/16.
//  Copyright © 2016 TorIsHere. All rights reserved.
//

import UIKit

@IBDesignable open class CircleView: UIView {

    @IBInspectable open var primaryColor: UIColor = UIColor.blue
    @IBInspectable open var secondaryColor: UIColor = UIColor.gray
    @IBInspectable open var bgColor: UIColor = UIColor.gray
    @IBInspectable open var lineWidth:CGFloat = 6
    @IBInspectable open var bgLineWidth:CGFloat = 6
    @IBInspectable open var startAngle:CGFloat = -90
    @IBInspectable open var endAngle:CGFloat = -90
    @IBInspectable open var willDraw:Bool = true
    
    var gradientLayer:CAGradientLayer!
    var pathLayer:CAShapeLayer!
    var path:UIBezierPath!
    var bgPath:UIBezierPath!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override open func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        path = UIBezierPath(arcCenter: center,
                            radius: radius/2 - lineWidth/2,
                            startAngle: self.startAngle.degreesToRadians,
                            endAngle: self.endAngle.degreesToRadians,
                            clockwise: true)
        
        path.lineWidth = lineWidth
        path.lineCapStyle = CGLineCap.round
            
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
