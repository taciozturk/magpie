//
//  RngTests.swift
//  magpie
//
//  Created by Taci Öztürk on 28.11.2026.
//

import Testing
@testable import magpie

struct RngTests {

    @Test("Seed zero")
    func seedZero(){
        var rng = Rng(seed: 0)
        let r = rng.next()

        #expect(r == 0xe220a8397b1dcdaf, "seed zero does not produce identical randoms as splitmax64 algorithm")
    }

    @Test("Seed zero next once")
    func seedZeroNext(){
        var rng = Rng(seed: 0)
        let _ = rng.next()
        let r = rng.next()

        #expect(r == 0x6e789e6aa1b965f4, "seed zero does not produce identical randoms as splitmax64 algorithm")
    }

    @Test("Same seed generates identical numbers")
    func sameSeed(){
        var rng1 = Rng(seed: 3342)
        var rng2 = Rng(seed: 3342)

        for _ in 0..<10_000 {
            #expect(rng1.next() == rng2.next(), "same seed does not produce the same random numbers")
        }
    }

    @Test("Random floats are between [0,1) and the mean is reasonable")
    func randomFloats(){
        var rng = Rng(seed: 3342)
        var total = 0.0
        let n = 10_1000

        for _ in 0..<n {
            let r = rng.nextFloat()
            #expect(r >= 0 && r < 1, "nextFloat() produced a value out of [0,1)")
            total += r
        }

        let mean = total / Double(n)

        #expect(mean > 0.49 && mean < 0.51, "random mean is not tolerable. tolerance: 0.01")
    }

    @Test("Different seeds generate different next values")
    func differentSeed(){
        var rng1 = Rng(seed: 3342)
        var rng2 = Rng(seed: 4233)

        #expect(rng1.next() != rng2.next(), "different seeds generated the same random number")
    }

}
