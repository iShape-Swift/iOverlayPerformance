//
//  ManySquaresUnionTest.swift
//  iOverlayPerformance
//
//  Created by Nail Sharipov on 11.12.2023.
//

import iFixFloat
import iShape
import iOverlay
import Foundation

// 125 - 0.5069899559020996
// 250 - 1.9692120552062988
// 500 - 7.39296293258667
// 1000 - 29.62079107761383

// 125 - 0.41172194480895996
// 250 - 1.7542951107025146
// 500 - 6.793500900268555
// 1000 - 28.831258058547974


struct ManySquaresUnionTest {
    
    func run() {

        let n = 500
        
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
        
        let start = Date()
        
        var overlay = Overlay()
        overlay.add(paths: subjPaths, type: .subject)
        overlay.add(paths: clipPaths, type: .subject)
        
        let graph = overlay.buildGraph(fillRule: .nonZero)
        
        let union = graph.extractShapes(overlayRule: .subject, minArea: 0)
        assert(!union.isEmpty)

        let end = Date()
        
        print("spend time: \(end.timeIntervalSince(start))")
        
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
