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

// 50 - 0.021960020065307617
// 100 - 0.09118402004241943
// 200 - 0.38771891593933105
// 300 - 0.8464930057525635
// 500 - 2.3891950845718384
// 1000 - 9.864031076431274
// 1500 - 23.118969082832336

// 50 - 0.01698005199432373
// 100 - 0.06737709045410156
// 200 - 0.2768009901046753
// 300 - 0.6432710886001587
// 500 - 1.7888659238815308
// 1000 - 7.374223947525024
// 1500 - 17.711047053337097

struct WindowsTest {
    
    func run() {

        let n = 1500
        let offset: Int32 = 30
        let a: Int32 = 20
        let b: Int32 = 10
        let x: Int32 = Int32(n) * offset / 2
        let start = Point(-x, -x)
        
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
     
     private func subjSquares(start: Point, a: Int32, offset: Int32, n: Int) -> ([Path]) {
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
    
    private func clipSquares(start: Point, a: Int32, b: Int32, offset: Int32, n: Int) -> ([Path]) {
        var result = [Path]()
        result.reserveCapacity(n * n)
        var y = start.y
        let c = (a - b) / 2
        let d = b + c
        for _ in 0..<n {
            var x = start.x
            for _ in 0..<n {
                let path: Path = [
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
