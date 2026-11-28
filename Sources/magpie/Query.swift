//
//  QueryEngine.swift
//  magpie
//
//  Created by Taci Öztürk on 28.11.2026.
//

public enum Query {

    public static func run<each W: Component, each O: Component, each A: Component, each C: Component>(
        _ world: World,
        with: repeat (each W).Type,
        without: repeat (each O).Type,
        anyOf: repeat (each A).Type,
        changed: repeat (each C).Type,
        do body: (Entity, repeat each W) -> Void
    ) {
        iterate(
            world.lastRun,
            body,
            with: repeat world.store(of: each with),
            without: repeat world.store(of: each without),
            anyOf: repeat world.store(of: each anyOf),
            changed: repeat world.store(of: each changed)
        )
    }

    public static func iterate<each W: Component, each O: Component, each A: Component, each C: Component>(
        _ since: UInt64,
        _ body: (Entity, repeat each W) -> Void,
        with: repeat ComponentStore<each W>,
        without: repeat ComponentStore<each O>,
        anyOf: repeat ComponentStore<each A>,
        changed: repeat ComponentStore<each C>,
    ) {
        var driver = ContiguousArray<Entity>()
        var smallest = Int.max
        var withCount = 0

        for store in repeat each with  {
            withCount += 1
            if store.entities.count < smallest {
                smallest = store.entities.count
                driver = store.entities
            }
        }

        precondition(withCount > 0, "query needs at least one with type")

        var anyCount = 0
        for _ in repeat each anyOf { anyCount += 1 }

        outer: for entity in driver {
            for store in repeat each with {
                if !store.has(entity) {
                    continue outer
                }
            }

            for store in repeat each without {
                if store.has(entity) {
                    continue outer
                }
            }

            for store in repeat each changed {
                if !store.changed(entity, since: since) {
                    continue outer
                }
            }

            if anyCount > 0 {
                var found = false
                for store in repeat each anyOf {
                    if store.has(entity) {
                        found = true
                    }
                }

                if !found {
                    continue
                }
            }

            body(entity, repeat (each with).getUnchecked(entity))
        }
    }

}
