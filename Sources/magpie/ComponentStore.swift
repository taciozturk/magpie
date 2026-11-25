//
//  Component.swift
//  magpie
//
//  Created by Taci Öztürk on 23.11.2026.
//

let INVALID_SLOT = UInt32.max

public struct ComponentStore<T> {
	public var components: ContiguousArray<T> = []
    public var changed: ContiguousArray<UInt64> = []
    public var entities: ContiguousArray<Entity> = []
    public var sparse: ContiguousArray<UInt32> = []
    public var clock: UInt64? = 0 // worlds change tick, needs passing

    public mutating func add(_ entity: Entity, _ component: T) {
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

    public func has(_ entity: Entity) -> Bool {
        if entity.id > sparse.count {
            return false
        }

        let slot = Int(sparse[Int(entity.id)])

        return slot != INVALID_SLOT && entities[slot] == entity
    }

    public func get(_ entity: Entity) -> T? {
        guard has(entity) else { return nil }

        return components[Int(sparse[Int(entity.id)])]
    }

    public mutating func remove(_ entity: Entity) {
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
