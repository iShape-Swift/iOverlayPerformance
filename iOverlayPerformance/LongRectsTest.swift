//
//  LongRectsTest.swift
//  iOverlayPerformance
//
//  Created by Nail Sharipov on 07.11.2023.
//

import iFixFloat
import iShape
import iOverlay
import Foundation

// 1.02
// 3 GHz 6-Core Intel Core i5, 40 GB 2667 MHz DDR4

// master
// 125 - 0.43621301651000977
// 250 - 2.763880968093872
// 500 - 18.6367369890213
// 1000 - 219.44416403770447

// 125 - 0.38937699794769287
// 250 - 2.3845399618148804
// 500 - 16.0730299949646
// 1000 - 117.0342628955841

// 125 - 0.33740293979644775
// 250 - 2.3845399618148804
// 500 - 13.026265978813171
// 1000 - 90.48865497112274

struct LongRectsTest {
    
    func run() {
        let n: Int64 = 500
        
        let subjPaths = self.longRects(
            start: .zero,
            size: FixVec(10, 20 * n),
            offset: FixVec(20, 0),
            n: Int(n)
        )
        
        let clipPaths = self.longRects(
            start: .zero,
            size: FixVec(20 * n, 10),
            offset: FixVec(0, 20),
            n: Int(n)
        )
        
        let start = Date()
        
        var overlay = Overlay()
        overlay.add(paths: subjPaths, type: .subject)
        overlay.add(paths: clipPaths, type: .clip)
        
        let graph = overlay.buildGraph()
        
        let clip = graph.extractShapes(overlayRule: .clip, minArea: 0)
        assert(!clip.isEmpty)
        
        let subject = graph.extractShapes(overlayRule: .subject, minArea: 0)
        assert(!subject.isEmpty)
        
        let difference = graph.extractShapes(overlayRule: .difference, minArea: 0)
        assert(!difference.isEmpty)
        
        let intersect = graph.extractShapes(overlayRule: .intersect, minArea: 0)
        assert(!intersect.isEmpty)
        
        let union = graph.extractShapes(overlayRule: .union, minArea: 0)
        assert(!union.isEmpty)
        
        let xor = graph.extractShapes(overlayRule: .xor, minArea: 0)
        assert(!xor.isEmpty)
        
        let end = Date()
        
        print("spend time: \(end.timeIntervalSince(start))")
        
    }
    
     
     private func longRects(start: FixVec, size: FixVec, offset: FixVec, n: Int) -> [FixPath] {
         var result = [FixPath]()
         result.reserveCapacity(n)
         var p = start
         for _ in 0..<n {
             let path: FixPath = [
                 p,
                 p + FixVec(0, size.y),
                 p + size,
                 p + FixVec(size.x, 0),
             ]
             
             result.append(path)
             
             p = p + offset
         }
         
         return result
     }
}
