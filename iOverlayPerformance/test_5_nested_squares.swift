//
//  СoncentricSquaresTest.swift
//  iOverlayPerformance
//
//  Created by Nail Sharipov on 25.01.2024.
//

import iFixFloat
import iShape
import iOverlay
import Foundation

// 3 GHz 6-Core Intel Core i5, 40 GB 2667 MHz DDR4

/*
 
test 5
 
 4     - 0.000022
 8     - 0.000045
 16     - 0.000098
 32     - 0.000238
 64     - 0.000624
 128     - 0.001853
 256     - 0.002398
 512     - 0.005013
 1024     - 0.011067
 2048     - 0.023194
 4096     - 0.050601
 8192     - 0.111691
 16384     - 0.252357
 32768     - 0.581991
 65536     - 1.368794
 131072     - 3.250746
 262144     - 8.529555
 524288     - 21.177892
*/

struct NestedSquaresTest {
    
    func run(n: Int, rule: OverlayRule) {

        let (subjPaths, clipPaths) = self.concentricSquares(a: 4, n: n)

        let it_count = max((500 / n), 1)
        let sq_it_count = it_count * it_count
        
        let start = Date()
        
        for _ in 0..<sq_it_count {
            let overlay = Overlay(subjShape: subjPaths, clipShape: clipPaths)
            let graph = overlay.buildGraph(fillRule: .evenOdd, solver: Solver.auto)
            _ = graph.extractShapes(overlayRule: rule)
        }

        let end = Date()
        let time = end.timeIntervalSince(start) / Double(sq_it_count)
        
        let polygons_count = 2 * n
        
        print("\(polygons_count)     - \(String(format: "%.6f", time))")
    }
     
    private func concentricSquares(a: Int32, n: Int) -> ([Path], [Path]) {
        var vert = [Path]()
        var horz = [Path]()
        vert.reserveCapacity(2 * n)
        horz.reserveCapacity(2 * n)
        
        let s = 2 * a
        var r = s
        for _ in 0..<n {
            let hz_top = [
                Point(-r, r - a),
                Point(-r, r),
                Point(r, r),
                Point(r, r - a)
            ]
            let hz_bot = [
                Point(-r, -r),
                Point(-r, -r + a),
                Point(r, -r + a),
                Point(r, -r)
            ]
            vert.append(hz_top)
            vert.append(hz_bot)

            let vt_left = [
                Point(-r, -r),
                Point(-r, r),
                Point(-r + a, r),
                Point(-r + a, -r)
            ]
            let vt_right = [
                Point(r - a, -r),
                Point(r - a, r),
                Point(r, r),
                Point(r, -r)
            ]
            horz.append(vt_left)
            horz.append(vt_right)

            r += s
        }

        return (vert, horz)
    }
  
}
