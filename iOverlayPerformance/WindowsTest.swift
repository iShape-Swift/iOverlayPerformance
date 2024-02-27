//
//  WindowsTest.swift
//  iOverlayPerformance
//
//  Created by Nail Sharipov on 25.01.2024.
//

import iFixFloat
import iShape
import iOverlay
import Foundation


// 50 - 0.031321048736572266
// 100 - 0.1493070125579834
// 200 - 0.7031810283660889
// 300 - 1.442452073097229
// 500 - 4.531200051307678
// 1000 - 17.91871201992035
// 1500 - 38.41665697097778

// 50 - 0.023594975471496582
// 100 - 0.0979909896850586
// 200 - 0.4112280607223511
// 300 - 0.9254159927368164
// 500 - 2.6547670364379883
// 1000 - 10.666239023208618
// 1500 - 24.240332007408142


// profile
// 1500:
// fill: 41.3

struct WindowsTest {
    
    func run() {

        let n = 1500
        let offset: Int64 = 30
        let a: Int64 = 20
        let b: Int64 = 10
        let x: Int64 = Int64(n) * offset / 2
        let start = FixVec(-x, -x)
        
        let subj = self.subjSquares(
            start: start,
            a: a,
            offset: offset,
            n: n
        )
        
        let clip = self.clipSquares(
            start: start,
            a: a,
            b: b,
            offset: offset,
            n: n
        )

        let timeStart = Date()
        
        var overlay = Overlay()
        overlay.add(paths: subj, type: .subject)
        overlay.add(paths: clip, type: .clip)
        let graph = overlay.buildGraph(fillRule: .nonZero)
        
        let diff = graph.extractShapes(overlayRule: .difference, minArea: 0)
        assert(diff.count == n * n)

        print("spend time: \(Date().timeIntervalSince(timeStart))")
        print("shapes count: \(subj.count)")
        
    }
     
     private func subjSquares(start: FixVec, a: FixFloat, offset: FixFloat, n: Int) -> ([FixPath]) {
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
    
    private func clipSquares(start: FixVec, a: FixFloat, b: FixFloat, offset: FixFloat, n: Int) -> ([FixPath]) {
        var result = [FixPath]()
        result.reserveCapacity(n * n)
        var y = start.y
        let c = (a - b) / 2
        let d = b + c
        for _ in 0..<n {
            var x = start.x
            for _ in 0..<n {
                let path: FixPath = [
                    .init(x + c, y + c),
                    .init(x + c, y + d),
                    .init(x + d, y + d),
                    .init(x + d, y + c)
                ]
                result.append(path)
                x += offset
            }
            y += offset
        }
        
        return result
    }

}
