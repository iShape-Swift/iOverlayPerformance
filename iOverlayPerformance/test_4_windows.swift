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
 
 2(4 0.6)     - 0.000018(-4.8)
 4(16 1.2)     - 0.000070(-4.2)
 8(64 1.8)     - 0.000309(-3.5)
 16(256 2.4)     - 0.001470(-2.8)
 32(1024 3.0)     - 0.006165(-2.2)
 64(4096 3.6)     - 0.026410(-1.6)
 128(16384 4.2)     - 0.113020(-0.9)
 256(65536 4.8)     - 0.493123(-0.3)
 512(262144 5.4)     - 2.045915(0.3)
 1024(1048576 6.0)     - 8.362559(0.9)
 2048(4194304 6.6)     - 33.551301(1.5)
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
        
        let polygons_count = n * n
        let count_log = log10(Double(polygons_count))
        let time_log = log10(time)
        

        print("\(n)(\(polygons_count) \(String(format: "%.1f", count_log)))     - \(String(format: "%.6f", time))(\(String(format: "%.1f", time_log)))")
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
