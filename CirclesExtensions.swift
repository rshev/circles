//
//  Extensions.swift
//  navTo
//
//  Created by asdfgh1 on 04/06/15.
//  Copyright (c) 2015 roman shevtsov. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    subscript (safe index: Int) -> T? {
        return indices(self) ~= index
            ? self[index]
            : nil
    }

    subscript (safe index: UInt) -> T? {
        return self[safe: Int(index)]
    }

}

extension UIColor {
    func lighten(amount: CGFloat = 0.25) -> UIColor {
        return hueColorWithBrightnessAmount(1 + amount)
    }
    
    func darken(amount: CGFloat = 0.25) -> UIColor {
        return hueColorWithBrightnessAmount(1 - amount)
    }
    
    private func hueColorWithBrightnessAmount(amount: CGFloat) -> UIColor {
        var hue         : CGFloat = 0
        var saturation  : CGFloat = 0
        var brightness  : CGFloat = 0
        var alpha       : CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue,
                saturation: saturation,
                brightness: brightness * amount,
                alpha: alpha)
        } else {
            return self
        }
    }
    
}
