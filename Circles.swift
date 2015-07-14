//
//  Circles.swift
//  circles
//
//  Created by Roman on 13/07/15.
//  Copyright (c) 2015 rshev. All rights reserved.
//

import UIKit
import DynamicColor

@IBDesignable
class Circles: UIView {

    @IBInspectable var orbitCount: Int = 5
    @IBInspectable var orbitColor: UIColor = UIColor(white: 0.9, alpha: 1.0)
    @IBInspectable var planetSizePercentage: CGFloat = 7
    @IBInspectable var planetColor: UIColor = UIColor.blackColor()
    @IBInspectable var selectedOrbit: Bool = false
    @IBInspectable var selectedOrbitNumber: Int = 1
    @IBInspectable var selectedColor: UIColor = UIColor.redColor()

//    let animDuration = 0.1
    
    private var planet: CAShapeLayer?
    private var orbits: [CAShapeLayer] = []
    
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
    
//    func resetLayers() {
//        planet?.removeFromSuperlayer()
//        planet = nil
//        orbits.map { $0.removeFromSuperlayer() }
//        orbits.removeAll(keepCapacity: false)
//        updateDrawing()
//    }
    
    func updateDrawing() {
        println(__FUNCTION__)

        var minDimension = self.bounds.width
        if self.bounds.height < minDimension { minDimension = self.bounds.height }
        let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)

        let planetRadius = minDimension * planetSizePercentage / 100
        
        let orbitRadiusStep = (minDimension - planetRadius*2) / CGFloat(orbitCount) / 2               // radius step
        var nextOrbitColor = orbitColor
        var lastRadius = minDimension / 2
        
//        var whiteComponentOrbit: CGFloat = 0
//        var whiteComponentPlanet: CGFloat = 0
//        let colorStepWhiteComponent: CGFloat
//        if orbitColor.getWhite(&whiteComponentOrbit, alpha: nil) && planetColor.getWhite(&whiteComponentPlanet, alpha: nil) {
//            colorStepWhiteComponent = abs(whiteComponentPlanet - whiteComponentOrbit) / CGFloat(orbitCount)
//        } else {
//            colorStepWhiteComponent = 0.1
//        }
//        println(colorStepWhiteComponent)
        
        for orbitIndex in 0..<orbitCount {
            var orbit = orbits[safe: orbitIndex]
            if orbit == nil {
                orbit = CAShapeLayer()
                self.layer.addSublayer(orbit)
                orbits.append(orbit!)
            }
            orbit?.frame = self.bounds
            orbit?.fillColor = nextOrbitColor.CGColor
            orbit?.path = UIBezierPath(arcCenter: center, radius: lastRadius, startAngle: CGFloat(0), endAngle: CGFloat(M_PI*2), clockwise: true).CGPath
            
            
            lastRadius -= orbitRadiusStep
            nextOrbitColor = nextOrbitColor.darkenColor(0.1)
        }
        
        if let orbit = orbits[safe: selectedOrbitNumber] where selectedOrbit {
            orbit.fillColor = selectedColor.CGColor
            let orbitAnim = CAKeyframeAnimation()
            orbitAnim.duration = 0.8
            orbitAnim.autoreverses = true
            orbitAnim.repeatCount = HUGE
            orbitAnim.values = [ NSValue(CATransform3D: CATransform3DMakeScale(0.96, 0.96, 0)), NSValue(CATransform3D: CATransform3DMakeScale(1.06, 1.06, 0)) ]
            orbitAnim.keyTimes = [0, 1]
            orbitAnim.timingFunctions = [ CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut) ]
            orbit.addAnimation(orbitAnim, forKey: "transform")
        }
        
        if planet == nil {
            planet = CAShapeLayer()
            self.layer.addSublayer(planet)
        }
        planet?.fillColor = planetColor.CGColor
        planet?.path = UIBezierPath(arcCenter: center, radius: planetRadius, startAngle: CGFloat(0), endAngle: CGFloat(M_PI*2), clockwise: true).CGPath
    }
    
}
