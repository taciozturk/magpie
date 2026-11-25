//
//  Entity.swift
//  magpie
//
//  Created by Taci Öztürk on 23.11.2026.
//

public struct Entity: Equatable, Hashable, Codable {
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

    public func destroy(_ entity: Entity) -> Bool {
        if !is_alive(entity) {
            return false
        }

        var gen = generations[Int(entity.id)] + 1
        if gen == 0 {
            gen = 1
        }

        generations[Int(entity.id)] = gen
        freeList.append(entity.id)
        return true
    }

    public func is_alive(_ entity: Entity) -> Bool {
        return entity.id < UInt32(generations.count) && generations[Int(entity.id)] == entity.generation
    }
}
