//
//  QueryTests.swift
//  magpie
//
//  Created by Taci Öztürk on 28.11.2026.
//

import Testing
@testable import magpie

struct QueryTests {

    @Test("Query single type")
    func query() {
        let world = World.create()
        let e1 = world.spawn()
        let e2 = world.spawn()
        let e3 = world.spawn()

        _ = world.register(storeOf: Position.self)

        world.queue(.addComponent(e1, Position(1, 1)))
        world.queue(.addComponent(e2, Position(2, 3)))
        world.queue(.addComponent(e3, Position(4, 5)))
        world.flush()

        var seen = [Float]()
        Query.run(world, with: Position.self) { _, p in seen.append(p.value.x) }
        #expect(seen.sorted() == [1, 2, 4])
    }
}
