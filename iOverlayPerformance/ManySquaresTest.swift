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
// 125 - 0.43583405017852783
// 250 - 1.8057969808578491
// 500 - 7.400161981582642
// 1000 - 30.35614001750946

// 125 - 0.23533731326460838
// 250 - 0.9990083128213882
// 500 - 4.50067526102066
// 1000 - 19.30902099609375


struct ManySquaresTest {
    
    func run() {

        let n = 1000
        
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
        var it_count = (1000 / n)
        it_count = max((it_count * it_count), 1)
        
        for _ in 0..<it_count {
            let overlay = Overlay(subjShape: subjPaths, clipShape: clipPaths)
            let graph = overlay.buildGraph(solver: Solver.auto)
            _ = graph.extractShapes(overlayRule: .xor, minArea: 0)
        }

        let end = Date()
        let time = end.timeIntervalSince(start) / Double(it_count)
        
        
        print("spend time: \(time)")
        
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
