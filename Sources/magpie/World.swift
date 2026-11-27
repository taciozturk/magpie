//
//  World.swift
//  magpie
//
//  Created by Taci Öztürk on 25.11.2026.
//

public final class World {
    package var clock = Clock()
    package var entities = EntityAllocator()
    package var stores: [ObjectIdentifier: any AnyComponentStore] = [:]
    package var commandBuffer = CommandBuffer()

    private init() {}

    public static func create() -> World {
        return World()
    }

    public func spawn() -> Entity {
        let e = entities.create()
        return e
    }

    public func despawn(entity: Entity) {
        if isAlive(entity) {
            for store in stores.values {
                if store.has(entity) {
                    store.remove(entity)
                }
            }
        }

        _ = entities.destroy(entity)
    }

    public func isAlive(_ entity: Entity) -> Bool {
        return entities.isAlive(entity)
    }

    public func register<T: Component>(storeOf componentType: T.Type) -> ComponentStore<T> {
        let key = ObjectIdentifier(T.self)
        precondition(stores[key] == nil, "component registered twice")
        let store = ComponentStore<T>(clock: clock)
        stores[key] = store
        return store
    }

    // since we derive the key to the store dictionary from the type of the component
    // we need to downcast the store to the concrete component type
    public func store<T: Component>(of componentType: T.Type) -> ComponentStore<T> {
        guard let s = stores[ObjectIdentifier(T.self)] else {
            preconditionFailure("component type not registered")
        }
        return unsafeDowncast(s, to: ComponentStore<T>.self)
    }

    public func queue(_ command: Command) {
        commandBuffer.queue(command)
    }

    public func flush() {
        for cmd in commandBuffer.commands {
            switch cmd {
                case .addComponent(let entity, let component):
                    // we use a helper function to pass the concrete component to the command buffer
                    guard entities.isAlive(entity) else { continue }
                    addComponent(entity, component)
                case .removeComponent(let entity, let componentType):
                    stores[componentType]?.remove(entity)
                case .destroyEntity(let entity):
                    despawn(entity: entity)
        	}
        }
        commandBuffer.clear()
    }

    private func addComponent<C: Component>(_ entity: Entity, _ component: C) {
        store(of: C.self).add(entity, component)
    }
}
