//
//  Entity.swift
//  magpie
//
//  Created by Taci Öztürk on 23.11.2026.
//

public struct Entity: Equatable, Hashable, Codable {
    public let id: UInt32
    public let generation: UInt32
}


public final class EntityAllocator {
    package var generations: ContiguousArray<UInt32> = []
    package var freeList: ContiguousArray<UInt32> = []

    package func create() -> Entity {
        if let index = freeList.popLast() {
            return Entity(id: index, generation: generations[Int(index)])
        }

        let index = UInt32(generations.count)
        generations.append(1)
        return Entity(id: index, generation: 1)
    }

    // make this discardable to prevent handling bool return in every usage "_ =" vice versa
    @discardableResult
    package func destroy(_ entity: Entity) -> Bool {
        if !isAlive(entity) {
            return false
        }


        var gen = generations[Int(entity.id)]
        gen &+= 1 // & to wrap if overflows
        if gen == 0 {
            gen = 1
        }
        generations[Int(entity.id)] = gen
        freeList.append(entity.id)
        return true
    }

    package func isAlive(_ entity: Entity) -> Bool {
        return entity.id < UInt32(generations.count) && generations[Int(entity.id)] == entity.generation
    }
}
