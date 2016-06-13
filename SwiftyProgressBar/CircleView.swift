//
//  CircleView.swift
//  TorProgressBar
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
    @IBInspectable var lineWidth:CGFloat = 10
    @IBInspectable var startAngle:CGFloat = -90
    @IBInspectable var endAngle:CGFloat = -90
    var path:UIBezierPath!
    var willDraw:Bool = true
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func drawRect(rect: CGRect) {
        // Drawing code
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        path = UIBezierPath(arcCenter: center,
            radius: radius/2 - lineWidth/2,
            startAngle: startAngle.degreesToRadians,
            endAngle: endAngle.degreesToRadians,
            clockwise: true)
        
        path.lineWidth = lineWidth
        if willDraw {
            primaryColor.setStroke()
            path.stroke()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    
    }
    
    required public init?(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
}