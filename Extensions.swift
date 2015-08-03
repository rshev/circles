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


