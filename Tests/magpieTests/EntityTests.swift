//
//  EntityTests.swift
//  magpie
//
//  Created by Taci Öztürk on 23.11.2026.
//

import Testing
@testable import magpie

struct EntityTests {

    @Test("Create entity")
    func create() {
        let ea = EntityAllocator()
        let e = ea.create()
        #expect(e.id == 0)
    }

    @Test("Destroy entity without creating any")
    func try_destroy() {
        let ea = EntityAllocator()
        let e = Entity(id: 1, generation: 1)
        let ok = ea.destroy(e)
        #expect(!ok)
    }

    @Test("Create then destroy entity")
    func destroy() {
        let ea = EntityAllocator()
        let e = ea.create()
        let ok = ea.destroy(e)
        #expect(ok)
    }


    @Test("Create then destroy entity then check is alive")
    func is_alive() {
        let ea = EntityAllocator()
        let e = Entity(id: 1, generation: 1)
        let _ = ea.destroy(e)
        #expect(!ea.is_alive(e))
    }

    @Test("Create destroy create, same id different generation")
    func create_destroy_create() {
        let ea = EntityAllocator()
        let e1 = ea.create()
        let _ = ea.destroy(e1)
        let e2 = ea.create()

        #expect(e1.id == e2.id)
        #expect(e1.generation != e2.generation)
    }

    @Test("Destroy same entity twice, freelist gains one entry not two")
    func destroy_twice() {
        let ea = EntityAllocator()
        let e = ea.create()
        let _ = ea.destroy(e)

        #expect(ea.freeList.count == 1)

        let _ = ea.destroy(e)

        #expect(ea.freeList.count == 1)
    }

    @Test("Empty entity is never alive")
    func create_empty_entity() {
        let ea = EntityAllocator()
        let e = Entity(id: 0, generation: 0)

        #expect(!ea.is_alive(e))
    }

    @Test("Entity out of range is not alive and does not crash")
    func create_out_of_range_entity() {
        let ea = EntityAllocator()
        let _ = ea.create()
        let _ = ea.create()
        let _ = ea.create()

        let e = Entity(id: 10, generation: 1)

        #expect(!ea.is_alive(e))
    }

}

