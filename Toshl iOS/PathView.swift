//
//  PathView.swift
//  Toshl iOS
//
//  Created by Marko Budal on 26/03/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import UIKit

let NoOfGlasses = 8
let π:CGFloat = CGFloat(M_PI)
var outlinePath:UIBezierPath!
class PathView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBInspectable
    var counter: Int = 5 {
        didSet {
            if counter <= NoOfGlasses{
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable
    var outlineColor: UIColor = UIColor.blueColor()
    @IBInspectable
    var counterColor: UIColor = UIColor.orangeColor()
    
    @IBInspectable
    var point: CGPoint = CGPoint(x: 10, y: 10) {
        didSet {
            setNeedsDisplay()
        }
    }
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        let center = CGPoint(x: bounds.width / 1.0/10.0 * 9, y: bounds.height)
        let radius:CGFloat = max(bounds.width, bounds.height)
        let arcWidth:CGFloat = 80
        let startAngle:CGFloat =   CGFloat(M_PI)
        let endAngle:CGFloat =  CGFloat(1.5 * M_PI)
        /*
        path = UIBezierPath(arcCenter: center, radius: bounds.width / 1.0/7.0 * 6 - arcWidth/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        path.lineWidth = arcWidth
        counterColor.setStroke()
        path.stroke()
        */
        
        let angleDifference: CGFloat = 2 * π - startAngle + endAngle
        let arcLengthPerGlass: CGFloat = angleDifference / CGFloat(NoOfGlasses)
        let outlineEndAngle = arcLengthPerGlass * CGFloat(counter) + startAngle

        outlinePath = UIBezierPath(arcCenter: center, radius: bounds.width / 1.0/7.0 * 6 - 2.5, startAngle: startAngle, endAngle: outlineEndAngle, clockwise: true)
        
        outlinePath.addArcWithCenter(center, radius: bounds.width / 1.0/7.0 * 6 - arcWidth + 2.5, startAngle: outlineEndAngle, endAngle: startAngle, clockwise: false)
        
        outlinePath.closePath()
        
        outlineColor.setStroke()
        outlinePath.lineWidth = 5.0
        outlinePath.stroke()
        
  //     println("Point: \(path.containsPoint(point))")
    }
    
}
