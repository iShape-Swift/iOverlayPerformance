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

// master
// 125 - 0.531622052192688
// 250 - 2.0265350341796875
// 500 - 7.711843967437744
// 1000 - 30.740682005882263

// 125 - 0.43583405017852783
// 250 - 1.8057969808578491
// 500 - 7.400161981582642
// 1000 - 30.35614001750946
struct ManySquaresTest {
    
    func run() {

        let n = 125
        
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
        overlay.add(paths: clipPaths, type: .clip)
        
        let graph = overlay.buildGraph()
        
//        let clip = graph.extractShapes(overlayRule: .clip, minArea: 0)
//        assert(!clip.isEmpty)
//        
//        let subject = graph.extractShapes(overlayRule: .subject, minArea: 0)
//        assert(!subject.isEmpty)
//        
//        let difference = graph.extractShapes(overlayRule: .difference, minArea: 0)
//        assert(!difference.isEmpty)
//        
//        let intersect = graph.extractShapes(overlayRule: .intersect, minArea: 0)
//        assert(!intersect.isEmpty)
        
        let union = graph.extractShapes(overlayRule: .union, minArea: 0)
        assert(!union.isEmpty)
        
//        let xor = graph.extractShapes(overlayRule: .xor, minArea: 0)
//        assert(!xor.isEmpty)

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
