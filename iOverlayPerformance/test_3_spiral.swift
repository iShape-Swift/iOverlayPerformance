//
//  test_3_saw_test.swift
//  iOverlayPerformance
//
//  Created by Nail Sharipov on 16.08.2024.
//

import iFixFloat
import iShape
import iOverlay
import Foundation
import CoreGraphics

// 3 GHz 6-Core Intel Core i5, 40 GB 2667 MHz DDR4

/*
 
test 3
 
 2     - 0.000006
 4     - 0.000010
 8     - 0.000019
 16     - 0.000040
 32     - 0.000095
 64     - 0.000218
 128     - 0.000490
 256     - 0.001116
 512     - 0.003274
 1024     - 0.006184
 2048     - 0.013051
 4096     - 0.026307
 8192     - 0.055343
 16384     - 0.111451
 32768     - 0.233838
 65536     - 0.473847
 131072     - 0.981729
 262144     - 1.979541
 524288     - 4.101912
 1048576     - 8.254108
*/

struct SpiralTest {
    
    func run(n: Int) {

        let subjPath = self.spiral(count: n, radius: 100)
        
        let it_count = max((1000 / n), 1)
        let sq_it_count = it_count * it_count

        let start = Date()
        
        for _ in 0..<sq_it_count {
            let overlay = CGOverlay(subjectPaths: [subjPath], clipPaths: [])
            let graph = overlay.buildGraph(solver: Solver.auto)
            _ = graph.extractShapes(overlayRule: .union)
        }

        let end = Date()
        let time = end.timeIntervalSince(start) / Double(sq_it_count)
        
        let polygons_count = n

        print("\(polygons_count)     - \(String(format: "%.6f", time))")
    }
    
     
    private func spiral(count: Int, radius: CGFloat) -> [CGPoint] {
        var aPath = [CGPoint]()
        var bPath = [CGPoint]()
        
        var a: CGFloat = 0
        var r = radius
        let w = 0.1 * radius
        
        let c0 = CGPoint(x: 0, y: 0)
        var p0 = c0

        for i in 0..<count {
            let sx = cos(a)
            let sy = sin(a)

            let rr: CGFloat
            
            if i % 2 == 0 {
                rr = r + 0.2 * radius
            } else {
                rr = r - 0.2 * radius
            }
            
            let p = CGPoint(x: rr * sx, y: rr * sy)
            let n = (p - p0).normalize
            let t = CGPoint(x: w * -n.y, y: w * n.x)

            aPath.append(p0 + t)
            aPath.append(p + t)
            bPath.append(p0 - t)
            bPath.append(p - t)
            
            a += radius / r
            r = radius * (1 + a / (2 * .pi))
            p0 = p
        }

        bPath.reverse()

        aPath.append(contentsOf: bPath)
        
        return aPath
     }

}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    CGPoint(x: left.x - right.x, y: left.y - right.y)
}


private extension CGPoint {
    
    var length: CGFloat {
        (x * x + y * y).squareRoot()
    }
    
    var normalize: CGPoint {
        let l = self.length
        return CGPoint(x: x / l, y: y / l)
    }
}
