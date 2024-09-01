//
//  WindowsTest.swift
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
 
test 4
 
 8     - 0.000016
 32     - 0.000062
 128     - 0.000276
 512     - 0.001306
 2048     - 0.005543
 8192     - 0.023805
 32768     - 0.104822
 131072     - 0.445712
 524288     - 1.862371
 2097152     - 7.657815
 8388608     - 30.833973
*/

struct WindowsTest {
    
    func run(n: Int, rule: OverlayRule) {

        let offset: Int32 = 30
        let x: Int32 = Int32(n) * offset / 2
        
        let (subjPaths, clipPaths) = self.manyWindows(
            start: Point(-x, -x),
            a: 20,
            b: 10,
            offset: offset,
            n: n
        )

        let it_count = max((500 / n), 1)
        let sq_it_count = it_count * it_count
        
        let start = Date()
        
        for _ in 0..<sq_it_count {
            let overlay = Overlay(subjShape: subjPaths, clipShape: clipPaths)
            let graph = overlay.buildGraph(solver: Solver.auto)
            _ = graph.extractShapes(overlayRule: rule)
        }

        let end = Date()
        let time = end.timeIntervalSince(start) / Double(sq_it_count)
        
        let polygons_count = 2 * n * n
        
        print("\(polygons_count)     - \(String(format: "%.6f", time))")
    }
    
    private func manyWindows(start: Point, a: Int32, b: Int32, offset: Int32, n: Int) -> ([Path], [Path]) {
        var boundaries = [Path]()
        boundaries.reserveCapacity(n * n)

        var holes = [Path]()
        holes.reserveCapacity(n * n)

        var y = start.y
        let c = (a - b) / 2
        let d = b + c
        for _ in 0..<n {
            var x = start.x
            for _ in 0..<n {
                let boundary = [
                    Point(x, y),
                    Point(x, y + a),
                    Point(x + a, y + a),
                    Point(x + a, y)
                ]
                boundaries.append(boundary)

                let hole = [
                    Point(x + c, y + c),
                    Point(x + c, y + d),
                    Point(x + d, y + d),
                    Point(x + d, y + c)
                ];
                holes.append(hole)

                x += offset
            }
            y += offset
        }

        return (boundaries, holes)
    }

}
