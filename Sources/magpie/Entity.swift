//
//  Entity.swift
//  magpie
//
//  Created by Taci Öztürk on 23.11.2026.
//

public struct Entity {
    public var id: UInt32
    public var generation: UInt32
}


public class EntityAllocator {
    public var generations: ContiguousArray<UInt32> = []
    public var freeList: ContiguousArray<UInt32> = []

    public func create() -> Entity {
        if let index = freeList.popLast() {
            return Entity(id: index, generation: generations[Int(index)])
        }

        let index = UInt32(generations.count)
        generations.append(1)
        return Entity(id: index, generation: 1)
    }

    public func destroy(e: Entity) -> Bool {
        if !is_alive(e: e) {
            return false
        }

        var gen = generations[Int(e.id)] + 1
        if gen == 0 {
            gen = 1
        }

        generations[Int(e.id)] = gen
        freeList.append(e.id)
        return true
    }

    public func is_alive(e: Entity) -> Bool {
        return e.id < UInt32(generations.count) && generations[Int(e.id)] == e.generation
    }
}
