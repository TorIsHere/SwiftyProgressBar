//
//  CircularProgressBar.swift
//  SwiftyProgressBar
//
//  Created by Kittikorn Ariyasuk on 2016/12/12.
//  Copyright © 2016 TorIsHere. All rights reserved.
//

import UIKit

@IBDesignable open class CircularProgressBar: BaseCircleView {
    open var isAnimate: Bool = true
    open var withPercentage: Bool = true
    
    private var _label: UILabel?
    private var _labelText: String = ""
    open var labelText: String {
        get {
            return self._labelText
        }
        set(newText) {
            self._labelText = newText
            setNeedsDisplay()
        }
    }
    
    private var _progress: CGFloat = 0.0
    open var cuurentProgress: CGFloat {
        get {
            return self._progress
        }
        set(newProgress) {
            var _newProgress = min(newProgress, 1.0)
            _newProgress = max(_newProgress, 0.0)
            self._progress = _newProgress
            setNeedsDisplay()
        }
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override open func draw(_ rect: CGRect) {
        if isAnimate {
            super.drawProgressBarWithAnimate(frame: bounds, progress: self._progress, fgColor: self.fgColor, bgColor: self.bgColor, callback: nil)
        
        } else {
            super.drawProgressBar(frame: bounds, progress: self._progress, fgColor: self.fgColor, bgColor: self.bgColor)
        }
        
        if withPercentage {
            if _label == nil {
                _label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
                let center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
                _label!.center = center
                _label!.textAlignment = .center
                _label!.textColor =  self.fgColor
                self.addSubview(_label!)
            }
            if let label = _label {
                label.text = "\(Int(_progress * 100)) %"
            }
        }
    }

}
