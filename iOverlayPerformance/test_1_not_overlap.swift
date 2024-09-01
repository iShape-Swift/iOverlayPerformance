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
 
 5     - 0.000009
 25     - 0.000041
 113     - 0.000204
 481     - 0.001052
 1985     - 0.004978
 8065     - 0.021336
 32513     - 0.089523
 130561     - 0.375594
 523265     - 1.663087
 2095105     - 6.947932
 8384513     - 28.777569
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
        
        print("\(polygons_count)     - \(String(format: "%.6f", time))")
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
