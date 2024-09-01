//
//  ManySquaresTest.swift
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
 
test 0
 
2(5 0.7)     - 0.000016(-4.8)
4(25 1.4)     - 0.000104(-4.0)
8(113 2.1)     - 0.000892(-3.0)
16(481 2.7)     - 0.002994(-2.5)
32(1985 3.3)     - 0.013012(-1.9)
64(8065 3.9)     - 0.057383(-1.2)
128(32513 4.5)     - 0.241604(-0.6)
256(130561 5.1)     - 1.023238(0.0)
512(523265 5.7)     - 4.590641(0.7)
1024(2095105 6.3)     - 19.441973(1.3)
2048(8384513 6.9)     - 85.024806(1.9)
*/
 
struct CheckerboardTest {
    
    func run(n: Int, rule: OverlayRule) {
        let subjPaths = self.manySuares(
            start: .zero,
            size: 20,
            offset: 30,
            n: n
        )
        
        let clipPaths = self.manySuares(
            start: Point(15, 15),
            size: 20,
            offset: 30,
            n: n - 1
        )
        
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
