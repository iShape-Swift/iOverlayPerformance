//
//  TestRandom_20.swift
//  iOverlayPerformance
//
//  Created by Nail Sharipov on 07.08.2023.
//

import CoreGraphics
import iOverlay
import iFixFloat

struct TestRandom_20 {
    
    static func run(count: Int) -> Int {
        
        let points = Self.randomPoints(count: count)
        
        let list = points.map({$0.fixVec})

        var overlay = Overlay()
        overlay.add(path: list, type: .subject)

        let shapes = overlay.buildSegments()
        return shapes.count

//        let segments = overlay.buildSegments()
//        return segments.count
    }
    
    
    
    private static func randomPoints(count: Int) -> [CGPoint] {
        var points = [CGPoint](repeating: .zero, count: count)

        for i in 0..<count {
            let x = CGFloat.random(in: -1..<1)
            let y = CGFloat.random(in: -1..<1)
            points[i] = CGPoint(x: x, y: y)
        }
        
        return points
    }
    
}
