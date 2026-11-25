//
//  World.swift
//  magpie
//
//  Created by Taci Öztürk on 25.11.2026.
//

public final class World {
    public var entities = EntityAllocator()
    public var commandBuffer = CommandBuffer()
    public var stores: [ObjectIdentifier:ComponentStore] = [:]
    public var clock: UInt64 = 1

    private init() {}

    public static func create() -> World {
        return World()
    }

    public func spawn() -> Entity {
        let e = entities.create()
        return e
    }

    public func isAlive(_ entity: Entity) -> Bool {
        return entities.isAlive(entity)
    }

    public func register(storeOf componentType: ObjectIdentifier) {
        if stores[componentType] == nil {
            stores[componentType] = ComponentStore()
        } else {
            return
        }
    }

    public func store(of componentType: ObjectIdentifier) -> ComponentStore {
        precondition(stores[componentType] != nil)
        return stores[componentType]!
    }

    public func queue(_ command: Command) {
        commandBuffer.queue(command)
    }

    public func flush() {
        for cmd in commandBuffer.commands {
            switch cmd {
                case .addComponent(let entity, let component):
                    stores[ObjectIdentifier(type(of: component))]?.add(entity, component)
                case .removeComponent(let entity, let componentType):
                    stores[componentType]?.remove(entity)
                case .destroyEntity(let entity):
                    let _ = entities.destroy(entity)
        	}
        }
        commandBuffer.commands.removeAll(keepingCapacity: true)
    }
}
