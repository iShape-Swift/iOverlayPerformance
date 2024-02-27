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


// 25 - 0.013188004493713379
// 50 - 0.11086499691009521
// 100 - 1.2763789892196655
// 200 - 17.22313404083252

// 25 - 0.0068089962005615234
// 50 - 0.03202998638153076
// 100 - 0.17943692207336426
// 200 - 1.0426030158996582

// profile
// 200:
// fill: 87.6


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
         result.reserveCapacity(n)
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
