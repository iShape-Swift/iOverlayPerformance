//
//  CGPoint.swift
//  iOverlayPerformance
//
//  Created by Nail Sharipov on 05.08.2023.
//

import CoreGraphics
import iFixFloat

extension CGPoint {
    
    var fixVec: FixVec {
        FixVec(x.fix, y.fix)
    }
    
}
