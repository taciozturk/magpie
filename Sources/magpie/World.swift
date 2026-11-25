//
//  World.swift
//  magpie
//
//  Created by Taci Öztürk on 25.11.2026.
//

public final class World {
    public var entities = EntityAllocator()
    public var cmdBuffer = CommandBuffer()
    public var stores: [ObjectIdentifier:ComponentStore] = [:]
}
