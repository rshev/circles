//
//  Circles.swift
//  circles
//
//  Created by Roman on 13/07/15.
//  Copyright (c) 2015 rshev. All rights reserved.
//

import UIKit

class Circles: UIView {

    @IBInspectable var orbits: Int = 5
    @IBInspectable var orbitColor: UIColor = .grayColor()
    @IBInspectable var planetSizePercentage: Int = 10
    @IBInspectable var planetColor: UIColor = .blackColor()
    @IBInspectable var satelliteSizePercentage: Int = 5
    @IBInspectable var satelliteColor: UIColor = .yellowColor()

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        println(self.frame)
    }
    
    func updateDrawing() {
        
    }
    
}
