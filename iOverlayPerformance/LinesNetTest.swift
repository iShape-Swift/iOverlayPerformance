//
//  LinesNetTest.swift
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

struct LinesNetTest {
    
    func run() {
        let n: Int = 1000
        
        let subjPaths = self.manyLinesX(a: 20, n: n)
        let clipPaths = self.manyLinesY(a: 20, n: n)
        
        let start = Date()
        
        let overlay = Overlay(subjectPaths: subjPaths, clipPaths: clipPaths)
        let graph = overlay.buildGraph()
        
        let intersect = graph.extractShapes(overlayRule: .intersect, minArea: 0)
        let end = Date()
        
        assert(!intersect.isEmpty)
        
        print("LinesNetTest time: \(end.timeIntervalSince(start))")
    }
    
     
     private func manyLinesX(a: Int32, n: Int) -> [Path] {
         var result = [Path]()
         result.reserveCapacity(n)
         
         let w = a / 2
         let s = a * Int32(n) / 2
         var x = -s + w / 2

         for _ in 0..<n {
             let path: Path = [
                 Point(x, -s),
                 Point(x, s),
                 Point(x + w, s),
                 Point(x + w, -s),
             ]
             
             result.append(path)
             x += a
         }
         
         return result
     }
    
    private func manyLinesY(a: Int32, n: Int) -> [Path] {
        var result = [Path]()
        result.reserveCapacity(n)
        
        let h = a / 2
        let s = a * Int32(n) / 2
        var y = -s + h / 2

        for _ in 0..<n {
            let path: Path = [
                Point(-s, y),
                Point(s, y),
                Point(s, y - h),
                Point(-s, y - h),
            ]
            
            result.append(path)
            y += a
        }
        
        return result
    }
}
