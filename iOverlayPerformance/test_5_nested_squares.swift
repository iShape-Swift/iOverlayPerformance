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
 
 2(2 0.3)     - 0.000025(-4.6)
 4(4 0.6)     - 0.000052(-4.3)
 8(8 0.9)     - 0.000111(-4.0)
 16(16 1.2)     - 0.000259(-3.6)
 32(32 1.5)     - 0.000668(-3.2)
 64(64 1.8)     - 0.001201(-2.9)
 128(128 2.1)     - 0.002529(-2.6)
 256(256 2.4)     - 0.005376(-2.3)
 512(512 2.7)     - 0.011426(-1.9)
 1024(1024 3.0)     - 0.024999(-1.6)
 2048(2048 3.3)     - 0.056221(-1.3)
 4096(4096 3.6)     - 0.115023(-0.9)
 8192(8192 3.9)     - 0.265232(-0.6)
 16384(16384 4.2)     - 0.587124(-0.2)
 32768(32768 4.5)     - 1.397917(0.1)
 65536(65536 4.8)     - 3.255069(0.5)
 131072(131072 5.1)     - 8.558105(0.9)
 262144(262144 5.4)     - 20.687412(1.3)
*/

struct NestedSquaresTest {
    
    func run(n: Int, rule: OverlayRule) {

        let (subjPaths, clipPaths) = self.concentricSquares(a: 4, n: n)

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
        
        let polygons_count = n
        let count_log = log10(Double(polygons_count))
        let time_log = log10(time)
        

        print("\(n)(\(polygons_count) \(String(format: "%.1f", count_log)))     - \(String(format: "%.6f", time))(\(String(format: "%.1f", time_log)))")
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
