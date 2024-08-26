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
 
 2(4 0.6)     - 0.000016(-4.8)
 4(8 0.9)     - 0.000052(-4.3)
 8(16 1.2)     - 0.000198(-3.7)
 16(32 1.5)     - 0.001328(-2.9)
 32(64 1.8)     - 0.005164(-2.3)
 64(128 2.1)     - 0.022341(-1.7)
 128(256 2.4)     - 0.063474(-1.2)
 256(512 2.7)     - 0.255476(-0.6)
 512(1024 3.0)     - 1.173511(0.1)
 1024(2048 3.3)     - 4.955951(0.7)
 2048(4096 3.6)     - 20.758480(1.3)
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
        let count_log = log10(Double(polygons_count))
        let time_log = log10(time)
        
        
        print("\(n)(\(polygons_count) \(String(format: "%.1f", count_log)))     - \(String(format: "%.6f", time))(\(String(format: "%.1f", time_log)))")
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
