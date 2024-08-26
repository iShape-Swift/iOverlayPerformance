//
//  main.swift
//  iOverlayPerformance
//
//  Created by Nail Sharipov on 07.11.2023.
//

run_test_0()
//run_test_1()
//run_test_2()
//run_test_3()
//run_test_4()
//run_test_5()

func run_test_0() {
    print("run Checkerboard test")
    for i in 1..<12 {
        let n = 1 << i
        CheckerboardTest().run(n: n, rule: .xor)
    }
}

func run_test_1() {
    print("run NotOverlap test")
    for i in 1..<12 {
        let n = 1 << i
        NotOverlapTest().run(n: n, rule: .xor)
    }
}

func run_test_2() {
    print("run LinesNet test")
    for i in 1..<12 {
        let n = 1 << i
        LinesNetTest().run(n: n, rule: .intersect)
    }
}

func run_test_3() {
    print("run Saw test")
    for i in 1..<12 {
        let n = 1 << i
        SawTest().run(n: n, rule: .intersect)
    }
}

func run_test_4() {
    print("run Window test")
    for i in 1..<12 {
        let n = 1 << i
        WindowsTest().run(n: n, rule: .difference)
    }
}

func run_test_5() {
    print("run NestedSquares test")
    for i in 1..<19 {
        let n = 1 << i
        NestedSquaresTest().run(n: n, rule: .union)
    }
}
