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

    subscript(_ e: Entity) -> T {
        get { components[Int(sparse[Int(e.id)])] }
        set { components[Int(sparse[Int(e.id)])] = newValue }
    }

    public mutating func add(e: Entity, c: T) {
        let id = Int(e.id)
        while sparse.count <= e.id {
            sparse.append(INVALID_SLOT)
        }

        let slot = sparse[id]
        if slot != INVALID_SLOT {
            assert(entities[Int(slot)] == e, "stale entity still owns a component slot")
            components[Int(slot)] = c
            changed[Int(slot)] = now()
            return
        }

        sparse[id] = UInt32(entities.count)
        components.append(c)
        changed.append(now())
        entities.append(e)
    }

    public func has(e: Entity) -> Bool {
        if e.id > sparse.count {
            return false
        }

        let slot = Int(sparse[Int(e.id)])

        return slot != INVALID_SLOT && entities[slot] == e
    }

    public mutating func remove(e: Entity) {
        guard has(e: e) else { return }

        let id = Int(e.id)
        let slot = Int(sparse[Int(e.id)])
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

    public func get(e: Entity) -> Entity? {
        guard has(e: e) else { return nil }

        return entities[Int(sparse[Int(e.id)])]
    }


    private func now() -> UInt64 {
        return clock ?? 0
    }

}
