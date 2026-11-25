//
//  Component.swift
//  magpie
//
//  Created by Taci Öztürk on 23.11.2026.
//

let INVALID_SLOT = UInt32.max

public protocol Component {}

public struct ComponentStore {
	private var components: ContiguousArray<Component> = []
    private var changed: ContiguousArray<UInt64> = []
    private var entities: ContiguousArray<Entity> = []
    private var sparse: ContiguousArray<UInt32> = []
    private var clock: UInt64? = 0 // worlds change tick, needs passing

    package mutating func add(_ entity: Entity, _ component: Component) {
        let id = Int(entity.id)
        while sparse.count <= entity.id {
            sparse.append(INVALID_SLOT)
        }

        let slot = sparse[id]
        if slot != INVALID_SLOT {
            assert(entities[Int(slot)] == entity, "stale entity still owns a component slot")
            components[Int(slot)] = component
            changed[Int(slot)] = now()
            return
        }

        sparse[id] = UInt32(entities.count)
        components.append(component)
        changed.append(now())
        entities.append(entity)
    }

    package func has(_ entity: Entity) -> Bool {
        if entity.id > sparse.count {
            return false
        }

        let slot = Int(sparse[Int(entity.id)])

        return slot != INVALID_SLOT && entities[slot] == entity
    }

    package func get(_ entity: Entity) -> Component? {
        guard has(entity) else { return nil }

        return components[Int(sparse[Int(entity.id)])]
    }

    package mutating func remove(_ entity: Entity) {
        guard has(entity) else { return }

        let id = Int(entity.id)
        let slot = Int(sparse[Int(entity.id)])
        let last = entities.count - 1

        if slot != last {
            entities[slot] = entities[last]
            components[slot] = components[last]
            sparse[Int(entities[slot].id)] = UInt32(slot) // swap the index of last with the index of removed slot
        }

        entities.removeLast()
        components.removeLast()
        sparse[id] = INVALID_SLOT
    }

    private func now() -> UInt64 {
        return clock ?? 0
    }

}
