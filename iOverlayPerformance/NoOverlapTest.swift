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

// master
// 100 - 0.09511005878448486
// 200 - 0.5207550525665283
// 300 - 1.495182991027832
// 500 - 5.948512077331543
// 1000 - 44.000017046928406
struct NoOverlapTest {
    
    func run() {

        let n = 1000
        
        let subjPaths = self.manySuares(
            start: .zero,
            size: 20,
            offset: 30,
            n: n
        )
        
        let start = Date()
        
        var overlay = Overlay()
        overlay.add(paths: subjPaths, type: .subject)
        
        let graph = overlay.buildGraph()

        let union = graph.extractShapes(overlayRule: .union, minArea: 0)
        assert(!union.isEmpty)

        let end = Date()
        
        print("spend time: \(end.timeIntervalSince(start))")
    }
    
     
     private func manySuares(start: FixVec, size a: FixFloat, offset: FixFloat, n: Int) -> [FixPath] {
         var result = [FixPath]()
         result.reserveCapacity(n * n)
         var y = start.y
         for _ in 0..<n {
             var x = start.x
             for _ in 0..<n {
                 let path: FixPath = [
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
