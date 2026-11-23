//
//  Component.swift
//  magpie
//
//  Created by Taci Öztürk on 23.11.2026.
//

let INVALID_SLOT = UInt32.max

public struct ComponentStore<T> {
	var components: ContiguousArray<T> = []
    var changed: ContiguousArray<UInt64> = []
    var entities: ContiguousArray<Entity> = []
    var sparse: ContiguousArray<UInt32> = []
    var clock: UInt64 = 0 // worlds change tick, needs passing
}
