//
//  Circles.swift
//  circles
//
//  Created by Roman on 13/07/15.
//  Copyright (c) 2015 rshev. All rights reserved.
//

import UIKit

protocol CirclesDelegate: class {
    func circlesSelectedOrbit(circles: Circles, selectedOrbitNumber: UInt)
}

@IBDesignable
class Circles: UIView {

    @IBInspectable var orbitCount: UInt = 5 {
        didSet {
            updateDrawing()
        }
    }
    @IBInspectable var orbitColor: UIColor = UIColor(white: 0.9, alpha: 1.0) {
        didSet {
            updateDrawing()
        }
    }
    @IBInspectable var orbitColorDarkenBy: CGFloat = 0.15 {
        didSet {
            updateDrawing()
        }
    }
    @IBInspectable var planetSizePercentage: CGFloat = 7 {
        didSet {
            updateDrawing()
        }
    }
    @IBInspectable var planetColor: UIColor = UIColor.blackColor() {
        didSet {
            updateDrawing()
        }
    }
    @IBInspectable var selectedOrbit: Bool = false {
        didSet {
            updateDrawing()
        }
    }
    @IBInspectable var selectedOrbitNumber: UInt = 1 {
        didSet {
            updateDrawing()
        }
    }
    @IBInspectable var selectedColor: UIColor = UIColor.redColor() {
        didSet {
            updateDrawing()
        }
    }
    @IBInspectable var selectionBiasPts: UInt = 10 {
        didSet {
            updateDrawing()
        }
    }
    @IBInspectable var allowTapSelect: Bool = true {
        willSet {
            tapGestureRecognizer.enabled = newValue
        }
    }
    @IBInspectable var animDuration: Double = 0.7 {
        didSet {
            updateDrawing()
        }
    }

    weak var delegate: CirclesDelegate?
    
    private var planet: CAShapeLayer?
    private var orbits: [CAShapeLayer] = []
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: "tapRecognize:")
    }()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateDrawing()
    }
    
    private func setup() {
        self.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.enabled = allowTapSelect
    }
    
    private func updateDrawing() {
//        println(__FUNCTION__)

        let minDimension = self.bounds.width < self.bounds.height ? self.bounds.width : self.bounds.height
        let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)

        let planetRadius = minDimension * planetSizePercentage / 100
        
        let orbitRadiusStep = (minDimension - planetRadius*2) / CGFloat(orbitCount) / 2               // radius step
        var nextOrbitColor = orbitColor
        var lastRadius = minDimension / 2
        
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
            nextOrbitColor = nextOrbitColor.darken(amount: orbitColorDarkenBy)
        }
        
        orbits.map { $0.removeAllAnimations() }
        let orbitNum = orbitCount - 1 - selectedOrbitNumber
        if let orbit = orbits[safe: orbitNum] where selectedOrbit {
            let boundingBox = CGPathGetBoundingBox(orbit.path)
            let minBoundingDimension = boundingBox.width < boundingBox.height ? boundingBox.width : boundingBox.height

            let selectionBiasPercentage = CGFloat(selectionBiasPts) / minBoundingDimension
            orbit.fillColor = selectedColor.CGColor
            let orbitAnim = CAKeyframeAnimation()
            orbitAnim.duration = animDuration
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
                    self.delegate?.circlesSelectedOrbit(self, selectedOrbitNumber: selectedOrbitNumber)
                    updateDrawing()
                    break
                }
            }
        }
    }
    
}
