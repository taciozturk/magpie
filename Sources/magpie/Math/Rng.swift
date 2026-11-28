//
//  Rng.swift
//  magpie
//
//  Created by Taci Öztürk on 28.11.2026.
//

public struct SplitMix64: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) {
        state = seed
    }

    public mutating func next() -> UInt64 {
        state &+= 0x9e3779b97f4a7c15
        var z = state
        z = (z ^ (z >> 30)) &* 0xbf58476d1ce4e5b9
        z = (z ^ (z >> 27)) &* 0x94d049bb133111eb
        return z ^ (z >> 31)
    }

    public mutating func nextFloat() -> Float64 {
        Float64(next() >> 11) * 0x1.0p-53
    }
}
