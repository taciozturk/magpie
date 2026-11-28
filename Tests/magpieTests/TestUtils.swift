//
//  TestUtils.swift
//  magpie
//
//  Created by Taci Öztürk on 28.11.2026.
//

import Testing
@testable import magpie

struct Position: Component {
    var value: Vec2

    init(_ x: Float, _ y: Float) {
        self.value = Vec2(x,y)
    }
}

struct Velocity: Component {
    var value: Vec2

    init(_ x: Float, _ y: Float) {
        self.value = Vec2(x, y)
    }
}

struct Health: Component {
    var value: Int
}

// empty marker component
struct Dead: Component {}
