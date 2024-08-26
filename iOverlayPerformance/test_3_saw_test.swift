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

// 3 GHz 6-Core Intel Core i5, 40 GB 2667 MHz DDR4

/*
 
test 3
 
 2(4 0.6)     - 0.000018(-4.7)
 4(8 0.9)     - 0.000069(-4.2)
 8(16 1.2)     - 0.000291(-3.5)
 16(32 1.5)     - 0.001436(-2.8)
 32(64 1.8)     - 0.005964(-2.2)
 64(128 2.1)     - 0.023890(-1.6)
 128(256 2.4)     - 0.102807(-1.0)
 256(512 2.7)     - 0.460195(-0.3)
 512(1024 3.0)     - 1.958230(0.3)
 1024(2048 3.3)     - 8.785529(0.9)
 2048(4096 3.6)     - 36.261625(1.6)
*/

struct SawTest {
    
    func run(n: Int, rule: OverlayRule) {

        let subjPaths = self.sawLinesX(a: 20, n: n)
        let clipPaths = self.sawLinesY(a: 20, n: n)
        
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
    
     
     private func sawLinesX(a: Int32, n: Int) -> [Path] {
         var result = [Path]()
         result.reserveCapacity(n)
         
         let w = a / 2
         let s = a * Int32(n) / 2
         var x = -s + w / 2

         for _ in 0..<n {
             let path: Path = [
                 Point(x, -s),
                 Point(x, s),
                 Point(x + w, -s)
             ]
             
             result.append(path)
             x += a
         }
         
         return result
     }
    
    private func sawLinesY(a: Int32, n: Int) -> [Path] {
        var result = [Path]()
        result.reserveCapacity(n)
        
        let h = a / 2
        let s = a * Int32(n) / 2
        var y = -s + h / 2

        for _ in 0..<n {
            let path: Path = [
                Point(-s, y),
                Point(s, y),
                Point(-s, y - h)
            ]
            
            result.append(path)
            y += a
        }
        
        return result
    }
}
