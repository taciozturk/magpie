//
//  CommandBuffer.swift
//  magpie
//
//  Created by Taci Öztürk on 23.11.2026.
//

public enum Command {
    case destroyEntity(_ entity: Entity)
    case addComponent(_ entity: Entity, _ component: Component)
    case removeComponent(_ entity: Entity, _ component: ObjectIdentifier)
}

public struct CommandBuffer {
    var commands = ContiguousArray<Command>()

    public mutating func queue(_ command: Command) {
        commands.append(command)
    }
}
