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
    @IBInspectable var selectionBiasPts: Int = 10
    @IBInspectable var allowTapSelect: Bool = true

//    let animDuration = 0.1
    
    private var planet: CAShapeLayer?
    private var orbits: [CAShapeLayer] = []
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
//    override func drawRect(rect: CGRect) {
//        super.drawRect(rect)
//        updateDrawing()
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateDrawing()
    }
    
    func setup() {
        if !allowTapSelect { return }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapRecognize:")
        self.addGestureRecognizer(tapGestureRecognizer)
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

        let minDimension = self.bounds.width < self.bounds.height ? self.bounds.width : self.bounds.height
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
        
        orbits.map { $0.removeAllAnimations() }
        let orbitNum = orbitCount - 1 - selectedOrbitNumber
        if let orbit = orbits[safe: orbitNum] where selectedOrbit {
            let boundingBox = CGPathGetBoundingBox(orbit.path)
            let minBoundingDimension = boundingBox.width < boundingBox.height ? boundingBox.width : boundingBox.height

            let selectionBiasPercentage = CGFloat(selectionBiasPts) / minBoundingDimension
            orbit.fillColor = selectedColor.CGColor
            let orbitAnim = CAKeyframeAnimation()
            orbitAnim.duration = 0.7
            orbitAnim.autoreverses = true
            orbitAnim.repeatCount = HUGE
            orbitAnim.values = [ NSValue(CATransform3D: CATransform3DMakeScale(1 - selectionBiasPercentage * 0.5, 1 - selectionBiasPercentage * 0.5, 0)), NSValue(CATransform3D: CATransform3DMakeScale(1 + selectionBiasPercentage * 1, 1 + selectionBiasPercentage * 1, 0)) ]
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
    
    func tapRecognize(gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state != .Ended { return }
        let point = gestureRecognizer.locationInView(self)
        for orbitIndex in reverse(0..<orbitCount) {
            if let orbit = orbits[safe: orbitIndex] {
                if CGPathContainsPoint(orbit.path, nil, point, false) {
                    selectedOrbit = true
                    let orbitNum = orbitCount - 1 - orbitIndex
                    selectedOrbitNumber = orbitNum
                    updateDrawing()
                    break
                }
            }
        }
    }
    
}
