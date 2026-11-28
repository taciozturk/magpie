//
//  WorldTests.swift
//  magpie
//
//  Created by Taci Öztürk on 25.11.2026.
//

import Testing
@testable import magpie

struct WorldTests {

    @Test("Register creates empty store")
    func spawnDistinct() {
        let world = World.create()
        let e1 = world.spawn()
        let e2 = world.spawn()

        #expect(world.isAlive(e1) && world.isAlive(e2))
        #expect(e1 != e2, "World spawns entities with the same id and generation")
    }

    @Test("Register creates empty store")
    func registerStore() {
        let world = World.create()
        world.register(storeOf: Position.self)
        let posStore = world.store(of: Position.self)

        #expect(posStore.entities.count == 0)
        #expect(posStore.components.count == 0)
    }

    @Test("Despawn clears every store")
    func despawnClearsStores() {
        let world = World.create()

        world.register(storeOf: Position.self)
        let posStore = world.store(of: Position.self)
        world.register(storeOf: Velocity.self)
        let velStore = world.store(of: Velocity.self)

        let e = world.spawn()

        world.queue(.addComponent(e, Position(1, 1)))
        world.queue(.addComponent(e, Velocity(2, 3)))
        world.flush()
		
        #expect(posStore.has(e), "Position store does not have the entity")
        #expect(velStore.has(e), "Velocity store does not have the entity")

        world.queue(.destroyEntity(e))
        world.flush()

        #expect(!posStore.has(e), "Position store has the entity after destroy")
        #expect(posStore.entities.count == 0)
        #expect(!velStore.has(e), "Velocity store has the entity after destroy")
        #expect(velStore.entities.count == 0)
        #expect(!world.isAlive(e), "Entity alive after destroy")
    }

    @Test("Despawn leaves other entites intact")
    func despawnEntities() {
        let world = World.create()

        world.register(storeOf: Position.self)
        let posStore = world.store(of: Position.self)

        let e1 = world.spawn()
        let e2 = world.spawn()

        world.queue(.addComponent(e1, Position(1, 1)))
        world.queue(.addComponent(e2, Position(2, 3)))
        world.queue(.destroyEntity(e1))
        world.flush()

        #expect(!posStore.has(e1), "Position store has the entity \(e1) after destroy")
        #expect(posStore.has(e2), "Position does not the entity \(e2)")
        #expect(posStore.get(e2) == Position(2,3), "Entity has the wrong position" )
        #expect(posStore.sparse[Int(e2.id)] == 0)
    }

    @Test("Despawn twice is noop")
    func despawnTwice() {
        let world = World.create()

        let e = world.spawn()
        world.queue(.destroyEntity(e))
        world.queue(.destroyEntity(e))
        world.flush()

        #expect(world.entities.freeList.count == 1)
    }

    @Test("Stale despawn does not touch reused slot")
    func staleDespawn() {
        let world = World.create()
        world.register(storeOf: Position.self)
        let posStore = world.store(of: Position.self)

        let e1 = world.spawn()
        world.queue(.destroyEntity(e1))
        world.flush()

        let e2 = world.spawn()
        world.queue(.addComponent(e2, Position(1, 1)))
        world.queue(.destroyEntity(e1))
        world.flush()

        #expect(posStore.has(e2), "e2 does not have position")
    }

    @Test("Queue add is deferred until flush")
    func queueAddDeferred() {
        let world = World.create()
        world.register(storeOf: Position.self)
        let posStore = world.store(of: Position.self)

        let e = world.spawn()
        world.queue(.addComponent(e, Position(1, 1)))

        #expect(!posStore.has(e), "Command buffer added component before flush")
        #expect(world.commandBuffer.commands.count == 1)

        world.flush()

        #expect(posStore.has(e))
        #expect(posStore.get(e) == Position(1,1))
    }

    @Test("Flush clears buffers")
    func flushClear() {
        let world = World.create()
        world.register(storeOf: Position.self)

        let e = world.spawn()
        world.queue(.addComponent(e, Position(1, 1)))
        world.queue(.removeComponent(e, Position.self))
        world.queue(.destroyEntity(e))

        #expect(world.commandBuffer.commands.count == 3)

        world.flush()

        #expect(!world.isAlive(e))
        #expect(world.commandBuffer.commands.count == 0)
    }

    @Test("Queue add last one wins")
    func queueAddLast() {
        let world = World.create()
        world.register(storeOf: Position.self)
        let posStore = world.store(of: Position.self)

        let e = world.spawn()
        world.queue(.addComponent(e, Position(1, 1)))
        world.queue(.addComponent(e, Position(2, 3)))
        world.flush()

        #expect(posStore.get(e) == Position(2,3))
    }

    @Test("Flush destroy then add ignores add")
    func flushDestroy() {
        let world = World.create()
        world.register(storeOf: Position.self)
        let posStore = world.store(of: Position.self)

        let e = world.spawn()
        world.queue(.destroyEntity(e))
        world.queue(.addComponent(e, Position(1, 1)))

        world.flush()

        #expect(!world.isAlive(e), "destroyed entity is alive")
        #expect(posStore.entities.count == 0)
    }

}

