//
//  Component.swift
//  magpie
//
//  Created by Taci Öztürk on 23.11.2026.
//

let INVALID_SLOT = UInt32.max

public protocol Component {}

// AnyComponentStore conforms to AnyObject so we can downcast it to the concrete type
// e.g. ComponentStore<T> becomes ComponentStore<Position>.
package protocol AnyComponentStore: AnyObject {
    var entities: ContiguousArray<Entity> { get }
    func has(_ entity: Entity) -> Bool
    func remove(_ entity: Entity)
    func changed(_ entity: Entity, since: UInt64) -> Bool
}

public final class Clock {
    package var now: UInt64 = 1
}

public final class ComponentStore<T: Component>: AnyComponentStore {
	package var components: ContiguousArray<T> = []
    package var changed: ContiguousArray<UInt64> = []
    package var entities: ContiguousArray<Entity> = []
    package var sparse: ContiguousArray<UInt32> = []
    package var clock: Clock // worlds change tick, needs passing

    package init(clock: Clock) {
    	self.clock = clock
    }

    package func add(_ entity: Entity, _ component: T) {
        let id = Int(entity.id)

        if sparse.count <= entity.id {
            sparse.append(contentsOf: repeatElement(INVALID_SLOT, count: id + 1 - sparse.count))
        }

        let slot = sparse[id]
        if slot != INVALID_SLOT {
            assert(entities[Int(slot)] == entity, "stale entity still owns a component slot")
            components[Int(slot)] = component
            changed[Int(slot)] = clock.now
            return
        }

        sparse[id] = UInt32(entities.count)
        components.append(component)
        changed.append(clock.now)
        entities.append(entity)
    }

    package func has(_ entity: Entity) -> Bool {
        if entity.id >= sparse.count {
            return false
        }

        let slot = Int(sparse[Int(entity.id)])

        return slot != INVALID_SLOT && entities[slot] == entity
    }

    package func get(_ entity: Entity) -> T? {
        guard has(entity) else { return nil }

        return components[Int(sparse[Int(entity.id)])]
    }

    // mutate the component in place while calling from world
    package func modify(_ entity: Entity, _ body: (inout T) -> Void) {
        guard has(entity) else { return }
        let slot = Int(sparse[Int(entity.id)])
        changed[slot] = clock.now
        body(&components[slot])
    }

    // readonly access to component. second generic R means we can call it from world and look inside
    // T: Component, R: the type of property of the component
    // let transform be the component
    // Transform {
    //	x: Float
    //	y: Float
    // }
    // calling the read and the closure body:
    // let x: Float? = store.read(e) { $0.x }
    // or
    // let x: Float? = store.read(e) { component in component.x }
    package func read<R>(_ e: Entity, _ body: (borrowing T) -> R) -> R? {
        guard has(e) else { return nil }
        return body(components[Int(sparse[Int(e.id)])])
    }

    package func remove(_ entity: Entity) {
        guard has(entity) else { return }

        let id = Int(entity.id)
        let slot = Int(sparse[Int(entity.id)])
        let last = entities.count - 1

        if slot != last {
            entities[slot] = entities[last]
            components[slot] = components[last]
            changed[slot] = changed[last]
            sparse[Int(entities[slot].id)] = UInt32(slot) // swap the index of last with the index of removed slot
        }

        entities.removeLast()
        components.removeLast()
        changed.removeLast()
        sparse[id] = INVALID_SLOT
    }

    package func changed(_ entity: Entity, since: UInt64) -> Bool {
        has(entity) && changed[Int(sparse[Int(entity.id)])] > since
    }

}
