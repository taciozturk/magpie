//
//  CommandBuffer.swift
//  magpie
//
//  Created by Taci Öztürk on 23.11.2026.
//

public enum Command {
    case destroyEntity
    case addComponent
    case removeComponent
}

public struct CommandBuffer {
    var commands = ContiguousArray<Command>()

    public mutating func queue(_ command: Command) {
        commands.append(command)
    }
}
