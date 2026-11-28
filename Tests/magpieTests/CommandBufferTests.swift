//
//  CommandBufferTests.swift
//  magpie
//
//  Created by Taci Öztürk on 28.11.2026.
//

import Testing
@testable import magpie

struct CommandBufferTests {

    @Test("Queue command create")
    func queueCommandCreate() {
        let world = World.create()
        let e = world.spawn()

        #expect(world.commandBuffer.commands.count == 0)
        world.queue(.addComponent(e, Position(1,1)))
        #expect(world.commandBuffer.commands.count == 1)
    }

    @Test("Spawn and queue command destroy then flush")
    func queueDestroy() {
        let world = World.create()
        let e = world.spawn()

        world.queue(.destroyEntity(e))
        world.flush()

        #expect(world.isAlive(e) == false)
    }

    @Test("Queue command add component")
    func addComponent() {
        let world = World.create()
        let e = world.spawn()
        let posStore = world.register(storeOf: Position.self)

        world.queue(.addComponent(e, Position(1,1)))
        world.flush()
        #expect(world.commandBuffer.commands.count == 0)

        let ok = world.isAlive(e)
        #expect(ok == true)


        #expect(posStore.has(e))

        if let pos = posStore.get(e) {
            #expect(pos.value == Vec2(1,1))
        }
    }

    @Test("Queue command add component then remove")
    func removeComponent() {
        let world = World.create()
        let e = world.spawn()
        print(e.id)

        let posStore = world.register(storeOf: Position.self)

        print(posStore.sparse.count)
        world.queue(.addComponent(e, Position(1,1)))
        world.queue(.removeComponent(e, ObjectIdentifier(Position.self)))
        world.flush()

        #expect(!posStore.has(e))
    }

}



