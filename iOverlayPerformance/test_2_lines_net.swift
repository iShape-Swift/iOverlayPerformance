//
//  LinesNetTest.swift
//  iOverlayPerformance
//
//  Created by Nail Sharipov on 07.11.2023.
//

import iFixFloat
import iShape
import iOverlay
import Foundation

// 3 GHz 6-Core Intel Core i5, 40 GB 2667 MHz DDR4

/*
 
test 2
 
 4     - 0.000014
 8     - 0.000049
 16     - 0.000195
 32     - 0.001295
 64     - 0.004994
 128     - 0.021239
 256     - 0.091427
 512     - 0.255989
 1024     - 1.146842
 2048     - 4.808548
 4096     - 20.190101
*/

struct LinesNetTest {
    
    func run(n: Int, rule: OverlayRule) {

        let subjPaths = self.manyLinesX(a: 20, n: n)
        let clipPaths = self.manyLinesY(a: 20, n: n)

        let it_count = max((1000 / n), 1)
        let sq_it_count = it_count * it_count
        
        let start = Date()
        
        for _ in 0..<sq_it_count {
            let overlay = Overlay(subjShape: subjPaths, clipShape: clipPaths)
            let graph = overlay.buildGraph(solver: Solver.auto)
            _ = graph.extractShapes(overlayRule: rule)
        }

        let end = Date()
        let time = end.timeIntervalSince(start) / Double(sq_it_count)
        
        let polygons_count = 2 * n
        
        
        print("\(polygons_count)     - \(String(format: "%.6f", time))")
    }
    
     
     private func manyLinesX(a: Int32, n: Int) -> [Path] {
         var result = [Path]()
         result.reserveCapacity(n)
         
         let w = a / 2
         let s = a * Int32(n) / 2
         var x = -s + w / 2

         for _ in 0..<n {
             let path: Path = [
                 Point(x, -s),
                 Point(x, s),
                 Point(x + w, s),
                 Point(x + w, -s),
             ]
             
             result.append(path)
             x += a
         }
         
         return result
     }
    
    private func manyLinesY(a: Int32, n: Int) -> [Path] {
        var result = [Path]()
        result.reserveCapacity(n)
        
        let h = a / 2
        let s = a * Int32(n) / 2
        var y = -s + h / 2

        for _ in 0..<n {
            let path: Path = [
                Point(-s, y),
                Point(s, y),
                Point(s, y - h),
                Point(-s, y - h),
            ]
            
            result.append(path)
            y += a
        }
        
        return result
    }
}
