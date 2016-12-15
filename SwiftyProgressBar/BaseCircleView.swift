//
//  BaseCircleView.swift
//  SwiftyProgressBar
//
//  Created by Kittikorn Ariyasuk on 2016/12/12.
//  Copyright © 2016 TorIsHere. All rights reserved.
//

import UIKit

let π:CGFloat = CGFloat(M_PI)

extension CGFloat {
    var doubleValue:      Double  { return Double(self) }
    var degreesToRadians: CGFloat { return CGFloat(doubleValue * M_PI / 180) }
    var radiansToDegrees: CGFloat { return CGFloat(doubleValue * 180 / M_PI) }
}

@IBDesignable open class BaseCircleView: UIView {
    let queue = DispatchQueue(label: "com.torishere.progress-queue")
    
    public enum CircleSize:CGFloat {
        case Big = 30
        case Medium = 15
        case Small = 8
    }
    
    @IBInspectable open var circleSize:CircleSize = .Medium
    @IBInspectable open var fgColor: UIColor = UIColor.blue
    @IBInspectable open var bgColor: UIColor = UIColor.gray
    @IBInspectable open var lineWidth:CGFloat = 6
    @IBInspectable open var bgLineWidth:CGFloat = 5
    @IBInspectable open var startAngle:CGFloat = -90
    @IBInspectable open var endAngle:CGFloat = -90
    @IBInspectable open var willDraw:Bool = true
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    open func drawProgressBar(frame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100), progress: CGFloat = 100, fgColor: UIColor = UIColor.blue, bgColor: UIColor = UIColor.gray) {
        
        let center = CGPoint(x:self.bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(self.bounds.width, bounds.height)
        
        
        let bgPath:UIBezierPath = UIBezierPath(arcCenter: center,
                                               radius: radius/2 - lineWidth/2,
                                               startAngle: -90,
                                               endAngle: 90,
                                               clockwise: true)
        bgPath.lineWidth = self.bgLineWidth
        bgColor.setStroke()
        bgPath.stroke()
        
        
        self.endAngle = self.startAngle + (progress * 360)
        let progressPath:UIBezierPath = self.generatePath(startAngle: self.startAngle, endAngle: self.endAngle, size: self.circleSize)
        fgColor.setStroke()
        progressPath.stroke()
    }
    
    open func drawProgressBarWithAnimate(frame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100), progress: CGFloat = 100, fgColor: UIColor = UIColor.blue, bgColor: UIColor = UIColor.gray, callback: (() -> Void)?) {
        
        let center = CGPoint(x:self.bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(self.bounds.width, bounds.height)
        
        
        let bgPath:UIBezierPath = UIBezierPath(arcCenter: center,
                                               radius: radius/2 - lineWidth/2,
                                               startAngle: -90,
                                               endAngle: 90,
                                               clockwise: true)
        bgPath.lineWidth = self.bgLineWidth
        bgColor.setStroke()
        bgPath.stroke()
        
        self.endAngle = self.startAngle + (progress * 360)
        let progressPath:UIBezierPath = self.generatePath(startAngle: self.startAngle, endAngle: self.endAngle, size: self.circleSize)
        fgColor.setStroke()
        
        let progressLayer = CAShapeLayer()
        progressLayer.path = progressPath.cgPath
        progressLayer.lineCap =  kCALineCapRound
        progressLayer.lineWidth = self.lineWidth
        progressLayer.lineJoin = kCALineJoinBevel
        progressLayer.strokeColor = self.fgColor.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(progressLayer)
        
        
        CATransaction.begin()
        
        CATransaction.setCompletionBlock({
            if let callback = callback {
                callback()
            }
        })
        
        self.progressAnimate(shapeLayer: progressLayer, progress: progress)
        CATransaction.commit()
        
    }
    
    open func hideView() {
        self.isHidden = true
    }
    
    private func progressAnimate(shapeLayer: CAShapeLayer, progress:CGFloat) {
        let animProgress = CABasicAnimation(keyPath: "strokeEnd")
        animProgress.fromValue         = 0.0
        animProgress.toValue           = 1.0
        animProgress.duration          = Double(progress) / 1.0
        animProgress.repeatCount       = 0
        shapeLayer.add(animProgress, forKey: "strokeEnd")
    }
    
    private func generatePath(startAngle:CGFloat, endAngle:CGFloat, size:CircleSize) -> UIBezierPath {
        let center = CGPoint(x:self.bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(self.bounds.width, bounds.height)
        
        let path = UIBezierPath(arcCenter: center,
                                radius: radius/2 - lineWidth/2,
                                startAngle: startAngle.degreesToRadians,
                                endAngle: endAngle.degreesToRadians,
                                clockwise: true)
        
        switch size {
            case .Big:
                path.lineWidth = CircleSize.Big.rawValue
            case .Medium:
                path.lineWidth = CircleSize.Medium.rawValue
            case .Small:
                path.lineWidth = CircleSize.Small.rawValue
            default:
                path.lineWidth = CircleSize.Medium.rawValue
        }
        
        path.lineCapStyle = CGLineCap.round

        return path
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

struct Future<T> {
    typealias FutureResultHandler = (T) -> ()
    typealias AsyncOperation = (@escaping FutureResultHandler) -> ()
    
    private let asyncOperation: AsyncOperation
    
    init(asyncOperation: @escaping AsyncOperation) {
        self.asyncOperation = asyncOperation
    }
    
    func resolve(_ handler: @escaping FutureResultHandler) {
        asyncOperation(handler)
    }
    
    func then<U>(_ next: @escaping (_ input: T, _ callback: @escaping (U) -> ()) -> ()) -> Future<U> {
        return Future<U> { (resultHandler) in
            self.resolve { firstResult in
                next(firstResult) { secondResult in
                    resultHandler(secondResult)
                }
            }
        }
    }
}






