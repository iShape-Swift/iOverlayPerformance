//
//  TestStar.swift
//  iOverlayPerformance
//
//  Created by Nail Sharipov on 05.08.2023.
//

import CoreGraphics
import iOverlay
import iFixFloat

struct TestStar {
    
    static func run(count: Int) -> Int {
        
        var s = 0

        var angle: Double = 0
        for _ in 0..<count {
            
            let pointsA = Self.generateStarPoints(
                smallRadius: 10,
                bigRadius: 20,
                count: 32,
                angle: angle
            )

            let pointsB = Self.generateStarPoints(
                smallRadius: 12,
                bigRadius: 24,
                count: 32,
                angle: 0
            )
            
            let starA = pointsA.map({$0.fixVec})
            let starB = pointsB.map({$0.fixVec})
            
            var overlay = Overlay()
            overlay.add(path: starA, type: .subject)
            overlay.add(path: starB, type: .clip)
            let segments = overlay.buildSegments()
            
            s += segments.count
            
            angle += 0.0001
        }
        
        return s
    }
    
    
    
    private static func generateStarPoints(smallRadius: CGFloat, bigRadius: CGFloat, count: Int, angle: Double) -> [CGPoint] {
        let dA = Double.pi / Double(count)
        var a: Double = angle
        
        var points = [CGPoint]()
        points.reserveCapacity(2 * count)
        
        for _ in 0..<count {
            let xR = bigRadius * cos(a)
            let yR = bigRadius * sin(a)
            
            a += dA

            let xr = smallRadius * cos(a)
            let yr = smallRadius * sin(a)
            
            a += dA
            
            points.append(CGPoint(x: xR, y: yR))
            points.append(CGPoint(x: xr, y: yr))
        }
        
        return points
    }
    
}
