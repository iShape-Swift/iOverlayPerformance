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
// 125 - 0.1150360107421875
// 250 - 0.5627189874649048
// 500 - 2.936911940574646
// 1000 - 11.564475059509277

// 125 - 0.0719980001449585
// 250 - 0.2924981117248535
// 500 - 1.2297450304031372
// 1000 - 5.037665009498596

// 125 - 0.04961192607879639
// 250 - 0.20985305309295654
// 500 - 0.8522219657897949
// 1000 - 3.533730983734131
struct NoOverlapTest {
    
    func run() {

        let n: Int32 = 1000
        
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
    
     
     private func manySuares(start: Point, size a: Int32, offset: Int32, n: Int32) -> [Path] {
         var result = [Path]()
         result.reserveCapacity(Int(n * n))
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
