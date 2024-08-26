//
//  NoOverlapTest.swift
//  iOverlayPerformance
//
//  Created by Nail Sharipov on 29.11.2023.
//

import iFixFloat
import iShape
import iOverlay
import Foundation

// 3 GHz 6-Core Intel Core i5, 40 GB 2667 MHz DDR4

/*
 
test 1
 
 2(5 0.7)     - 0.000010(-5.0)
 4(25 1.4)     - 0.000046(-4.3)
 8(113 2.1)     - 0.000225(-3.6)
 16(481 2.7)     - 0.001274(-2.9)
 32(1985 3.3)     - 0.005460(-2.3)
 64(8065 3.9)     - 0.023239(-1.6)
 128(32513 4.5)     - 0.098134(-1.0)
 256(130561 5.1)     - 0.408358(-0.4)
 512(523265 5.7)     - 1.833687(0.3)
 1024(2095105 6.3)     - 7.634835(0.9)
 2048(8384513 6.9)     - 31.806825(1.5)
*/
struct NotOverlapTest {
    
    func run(n: Int, rule: OverlayRule) {
        
        let subjPaths = self.manySuares(start: .zero, size: 10, offset: 30, n: n)
        let clipPaths = self.manySuares(start: Point(15, 15), size: 10, offset: 30, n: n - 1)

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
        
        let polygons_count = n * n + (n - 1) * (n - 1)
        let count_log = log10(Double(polygons_count))
        let time_log = log10(time)
        

        print("\(n)(\(polygons_count) \(String(format: "%.1f", count_log)))     - \(String(format: "%.6f", time))(\(String(format: "%.1f", time_log)))")
    }

     
     private func manySuares(start: Point, size a: Int32, offset: Int32, n: Int) -> [Path] {
         var result = [Path]()
         result.reserveCapacity(n * n)
         var y = start.y
         for _ in 0..<n {
             var x = start.x
             for _ in 0..<n {
                 let path: Path = [
                     .init(x, y),
                     .init(x, y + a),
                     .init(x + a, y + a),
                     .init(x + a, y)
                 ]
                 result.append(path)
                 x += offset
             }
             y += offset
         }
         
         return result
     }
}
