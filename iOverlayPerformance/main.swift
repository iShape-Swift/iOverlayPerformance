//
//  main.swift
//  iOverlayPerformance
//
//  Created by Nail Sharipov on 05.08.2023.
//

import Foundation

print("Start")


let t0 = Date()

//let result = TestStar.run(count: 100000)
let result = TestRandom_20.run(count: 500)


let t1 = Date()

print(result)

print("time: \(t1.timeIntervalSince(t0))")


/// 100000 => 25
