//
//  CommandBuffer.swift
//  magpie
//
//  Created by Taci Öztürk on 23.11.2026.
//

public enum Command<T> {
    case destroyEntity(e: Entity)
    case addComponent(e: Entity, c: T)
    case removeComponent(e: Entity, t: T.Type)
}

public struct CommandBuffer<T> {
    var commands: ContiguousArray<Command<T>> = []

    public mutating func queue(c: Command<T>) {
        switch c {
            case let .destroyEntity( e):
                commands.append(.destroyEntity(e: e))
            case let .addComponent(e: e, c: c):
                commands.append(.addComponent(e: e, c: c))
            case let .removeComponent(e: e, t: t):
                commands.append(.removeComponent(e: e, t: t))
        }
    }
}
