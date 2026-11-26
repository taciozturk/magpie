//
//  CommandBuffer.swift
//  magpie
//
//  Created by Taci Öztürk on 23.11.2026.
//

public enum Command {
    case destroyEntity(Entity)
    case addComponent(Entity, any Component)
    case removeComponent(Entity, ObjectIdentifier)
}

public struct CommandBuffer {
    package private(set) var commands = ContiguousArray<Command>()

    package mutating func queue(_ command: Command) {
        commands.append(command)
    }

    package mutating func clear() {
        commands.removeAll(keepingCapacity: true)
    }
}
