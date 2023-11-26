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

// 1.02

// 100 - 4.927271008491516
// 200 - 73.26099109649658
// 300 - 379.37199997901917

// master
// 100 - 0.8697209358215332
// 200 - 5.726709961891174
// 300 - 18.18790304660797
// 500 - 88.21195793151855
struct ManySquaresTest {
    
    func run() {

        let n = 100
        
        let subjPaths = self.manySuares(
            start: .zero,
            size: 20,
            offset: 30,
            n: n
        )
        
        let clipPaths = self.manySuares(
            start: FixVec(15, 15),
            size: 20,
            offset: 30,
            n: n - 1
        )
        
        let start = Date()
        
        var overlay = Overlay()
        overlay.add(paths: subjPaths, type: .subject)
        overlay.add(paths: clipPaths, type: .clip)
        
        let graph = overlay.buildGraph()
        
        let clip = graph.extractShapes(fillRule: .clip, minArea: 0)
        assert(!clip.isEmpty)
        
        let subject = graph.extractShapes(fillRule: .subject, minArea: 0)
        assert(!subject.isEmpty)
        
        let difference = graph.extractShapes(fillRule: .difference, minArea: 0)
        assert(!difference.isEmpty)
        
        let intersect = graph.extractShapes(fillRule: .intersect, minArea: 0)
        assert(!intersect.isEmpty)
        
        let union = graph.extractShapes(fillRule: .union, minArea: 0)
        assert(!union.isEmpty)
        
        let xor = graph.extractShapes(fillRule: .xor, minArea: 0)
        assert(!xor.isEmpty)

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
