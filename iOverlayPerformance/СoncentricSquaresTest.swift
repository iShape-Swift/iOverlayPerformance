//
//  СoncentricSquaresTest.swift
//  iOverlayPerformance
//
//  Created by Nail Sharipov on 25.01.2024.
//

import iFixFloat
import iShape
import iOverlay
import Foundation


// 100 - 1.9637190103530884
// 200 - 27.933372020721436
struct СoncentricSquaresTest {
    
    func run() {

        let n = 200
        let m = n * n
        let b: Int64 = 4
        let subj = self.squares(
            a: b,
            b: b,
            n: m
        )
        
        let clip = self.squares(
            a: b / 2,
            b: b,
            n: m
        )

        let timeStart = Date()
        
        var overlay = Overlay()
        overlay.add(paths: subj, type: .subject)
        overlay.add(paths: clip, type: .clip)
        let graph = overlay.buildGraph(fillRule: .nonZero)
        
        let diff = graph.extractShapes(overlayRule: .xor, minArea: 0)
        assert(diff.count == n)

        print("spend time: \(Date().timeIntervalSince(timeStart))")
        print("shapes count: \(subj.count)")
    }
     
     private func squares(a: FixFloat, b: FixFloat, n: Int) -> [FixPath] {
         var result = [FixPath]()
         result.reserveCapacity(n * n)
         var r = a
         for _ in 0..<n {
             let path: FixPath = [
                 .init(-r, -r),
                 .init(-r, r),
                 .init(r, r),
                 .init(r, -r)
             ]
             result.append(path)

             r += b
         }
         
         return result
     }
  
}
