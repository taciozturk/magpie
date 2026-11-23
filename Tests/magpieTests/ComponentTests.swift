//
//  ComponentTests.swift
//  magpie
//
//  Created by Taci Öztürk on 23.11.2026.
//

import Testing
@testable import magpie

struct Transform {
	var x: Float32
	var y: Float
}

struct ComponentTests {
    @Test("Create component")
    func create() {
        let ea = EntityAllocator()
        let e1 = ea.create()
        let e2 = ea.create()
        let e3 = ea.create()

        var store = ComponentStore<Transform>()
        store.add(e: e1, c: Transform(x: 1, y: 1))
        store.add(e: e2, c: Transform(x: 2, y: 2))
        store.add(e: e3, c: Transform(x: 3, y: 3))

        #expect(store.components[Int(store.sparse[Int(e1.id)])].x == 1)
        #expect(store.components[Int(store.sparse[Int(e2.id)])].x == 2)
        #expect(store.components[Int(store.sparse[Int(e3.id)])].x == 3)
    }
}
