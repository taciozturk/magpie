//
//  Matrix4.swift
//  magpie
//
//  Created by Taci Öztürk on 28.11.2026.
//

public struct Matrix4: Equatable, Hashable, Codable, Sendable {
    public var cx: Vec4
    public var cy: Vec4
    public var cz: Vec4
    public var cw: Vec4

    public var determinant: Float {
        let s0 = cx.x * cy.y - cy.x * cx.y
        let s1 = cx.x * cy.z - cy.x * cx.z
        let s2 = cx.x * cy.w - cy.x * cx.w
        let s3 = cx.y * cy.z - cy.y * cx.z
        let s4 = cx.y * cy.w - cy.y * cx.w
        let s5 = cx.z * cy.w - cy.z * cx.w

        let c5 = cz.z * cw.w - cw.z * cz.w
        let c4 = cz.y * cw.w - cw.y * cz.w
        let c3 = cz.y * cw.z - cw.y * cz.z
        let c2 = cz.x * cw.w - cw.x * cz.w
        let c1 = cz.x * cw.z - cw.x * cz.z
        let c0 = cz.x * cw.y - cw.x * cz.y

        return s0 * c5 - s1 * c4 + s2 * c3 + s3 * c2 - s4 * c1 + s5 * c0
    }

    public var trace: Float {
        cx.x + cy.y + cz.z + cw.w
    }

    public init(cx: Vec4, cy: Vec4, cz: Vec4, cw: Vec4) {
        self.cx = cx
        self.cy = cy
        self.cz = cz
        self.cw = cw
    }

    public init(_ cx: Vec4, _ cy: Vec4, _ cz: Vec4, _ cw: Vec4) {
        self.cx = cx
        self.cy = cy
        self.cz = cz
        self.cw = cw
    }

    public static let identity = Matrix4(
        cx: Vec4(x: 1, y: 0, z: 0, w: 0),
        cy: Vec4(x: 0, y: 1, z: 0, w: 0),
        cz: Vec4(x: 0, y: 0, z: 1, w: 0),
        cw: Vec4(x: 0, y: 0, z: 0, w: 1)
    )

    public static prefix func - (m: Matrix4) -> Matrix4 {
        Matrix4(cx: -m.cx, cy: -m.cy, cz: -m.cz, cw: -m.cw)
    }

    public static func + (lhs: Matrix4, rhs: Matrix4) -> Matrix4 {
        Matrix4(cx: lhs.cx + rhs.cx, cy: lhs.cy + rhs.cy, cz: lhs.cz + rhs.cz, cw: lhs.cw + rhs.cw)
    }

    public static func - (lhs: Matrix4, rhs: Matrix4) -> Matrix4 {
        Matrix4(cx: lhs.cx - rhs.cx, cy: lhs.cy - rhs.cy, cz: lhs.cz - rhs.cz, cw: lhs.cw - rhs.cw)
    }

    public static func * (lhs: Matrix4, rhs: Float) -> Matrix4 {
        Matrix4(cx: lhs.cx * rhs, cy: lhs.cy * rhs, cz: lhs.cz * rhs, cw: lhs.cw * rhs)
    }

    public static func * (lhs: Float, rhs: Matrix4) -> Matrix4 {
        rhs * lhs
    }

    public static func * (lhs: Matrix4, rhs: Vec4) -> Vec4 {
        lhs.cx * rhs.x + lhs.cy * rhs.y + lhs.cz * rhs.z + lhs.cw * rhs.w
    }

    public static func * (lhs: Matrix4, rhs: Matrix4) -> Matrix4 {
        Matrix4(
            cx: lhs * rhs.cx,
            cy: lhs * rhs.cy,
            cz: lhs * rhs.cz,
            cw: lhs * rhs.cw
        )
    }

    public static func / (lhs: Matrix4, rhs: Float) -> Matrix4 {
        Matrix4(cx: lhs.cx / rhs, cy: lhs.cy / rhs, cz: lhs.cz / rhs, cw: lhs.cw / rhs)
    }
}
