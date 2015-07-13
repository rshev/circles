//
//  Circles.swift
//  circles
//
//  Created by Roman on 13/07/15.
//  Copyright (c) 2015 rshev. All rights reserved.
//

import UIKit

@IBDesignable
class Circles: UIView {

    @IBInspectable var orbitCount: Int = 5 {
        didSet {
            resetLayers()
        }
    }
    @IBInspectable var orbitColor: UIColor = UIColor.redColor()
    @IBInspectable var orbitThicknessPercentage: CGFloat = 1
    @IBInspectable var planetSizePercentage: CGFloat = 10
    @IBInspectable var planetColor: UIColor = UIColor.greenColor()
    @IBInspectable var satelliteSizePercentage: CGFloat = 5
    @IBInspectable var satelliteColor: UIColor = UIColor.yellowColor()

    let animDuration = 0.1
    
    var planet: CAShapeLayer?
    var orbits: [CAShapeLayer] = []
    var satellite: CAShapeLayer?
    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        updateDrawing()
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        updateDrawing()
//    }
    
//    override func drawRect(rect: CGRect) {
//        super.drawRect(rect)
//        updateDrawing()
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateDrawing()
    }
    
    func resetLayers() {
        planet?.removeFromSuperlayer()
        planet = nil
        satellite?.removeFromSuperlayer()
        satellite = nil
        orbits.map { $0.removeFromSuperlayer() }
        orbits.removeAll(keepCapacity: false)
        updateDrawing()
    }
    
    func updateDrawing() {
        println(__FUNCTION__)

        var minDimension = self.bounds.width
        if self.bounds.height < minDimension { minDimension = self.bounds.height }
        let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        
        if planet == nil {
            planet = CAShapeLayer()
            self.layer.addSublayer(planet)
        }
        planet?.fillColor = planetColor.CGColor
        var lastRadius = minDimension * planetSizePercentage / 100
        planet?.path = UIBezierPath(arcCenter: center, radius: lastRadius, startAngle: CGFloat(0), endAngle: CGFloat(M_PI*2), clockwise: true).CGPath
        
        let planetAnim = CABasicAnimation()
        planetAnim.fromValue = UIBezierPath(arcCenter: center, radius: CGFloat(0.1), startAngle: CGFloat(0), endAngle: CGFloat(M_PI*2), clockwise: true).CGPath
        planetAnim.duration = animDuration
        planet?.addAnimation(planetAnim, forKey: "path")
        
        let orbitRadiusStep = (minDimension - lastRadius) / CGFloat(orbitCount) / 2               // radius step
        var animStep = animDuration
        
        for orbitIndex in 0..<orbitCount {
            var orbit = orbits[safe: orbitIndex]
            if orbit == nil {
                orbit = CAShapeLayer()
                self.layer.addSublayer(orbit)
                orbits.append(orbit!)
            }
            orbit?.fillColor = UIColor.clearColor().CGColor
            orbit?.strokeColor = orbitColor.CGColor
            orbit?.path = UIBezierPath(arcCenter: center, radius: lastRadius + orbitRadiusStep, startAngle: CGFloat(0), endAngle: CGFloat(M_PI*2), clockwise: true).CGPath
            orbit?.opacity = 0.0
            
            let orbitAnimGroup = CAAnimationGroup()
            let orbitAnim = CABasicAnimation(keyPath: "path")
            orbitAnim.fromValue = UIBezierPath(arcCenter: center, radius: lastRadius, startAngle: CGFloat(0), endAngle: CGFloat(M_PI*2), clockwise: true).CGPath
            let orbitAnimOpacity = CABasicAnimation(keyPath: "opacity")
            orbitAnimOpacity.toValue = 1.0
            orbitAnimGroup.removedOnCompletion = false
            orbitAnimGroup.fillMode = kCAFillModeForwards
            orbitAnimGroup.animations = [orbitAnim, orbitAnimOpacity]
            orbitAnimGroup.duration = animDuration
            orbitAnimGroup.beginTime = CACurrentMediaTime() + animStep
            orbit?.addAnimation(orbitAnimGroup, forKey: "group")
            
            lastRadius += orbitRadiusStep
            animStep += animDuration
            
            
            
        }
        
        

        
        
        
        
    }
    
}
