//
//  Matrix3.swift
//  magpie
//
//  Created by Taci Öztürk on 28.11.2026.
//

public struct Matrix3: Equatable, Hashable, Codable, Sendable {
    public var cx: Vec3
    public var cy: Vec3
    public var cz: Vec3

    public var determinant: Float {
        cx.x * (cy.y * cz.z - cy.z * cz.y)
            - cx.y * (cy.x * cz.z - cy.z * cz.x)
            + cx.z * (cy.x * cz.y - cy.y * cz.x)
    }

    public var trace: Float {
        cx.x + cy.y + cz.z
    }

    public init(cx: Vec3, cy: Vec3, cz: Vec3) {
        self.cx = cx
        self.cy = cy
        self.cz = cz
    }

    public init(_ cx: Vec3, _ cy: Vec3, _ cz: Vec3) {
        self.cx = cx
        self.cy = cy
        self.cz = cz
    }

    public static let identity = Matrix3(
        cx: Vec3(x: 1, y: 0, z: 0),
        cy: Vec3(x: 0, y: 1, z: 0),
        cz: Vec3(x: 0, y: 0, z: 1)
    )

    public static prefix func - (m: Matrix3) -> Matrix3 {
        Matrix3(cx: -m.cx, cy: -m.cy, cz: -m.cz)
    }

    public static func + (lhs: Matrix3, rhs: Matrix3) -> Matrix3 {
        Matrix3(cx: lhs.cx + rhs.cx, cy: lhs.cy + rhs.cy, cz: lhs.cz + rhs.cz)
    }

    public static func - (lhs: Matrix3, rhs: Matrix3) -> Matrix3 {
        Matrix3(cx: lhs.cx - rhs.cx, cy: lhs.cy - rhs.cy, cz: lhs.cz - rhs.cz)
    }

    public static func * (lhs: Matrix3, rhs: Float) -> Matrix3 {
        Matrix3(cx: lhs.cx * rhs, cy: lhs.cy * rhs, cz: lhs.cz * rhs)
    }

    public static func * (lhs: Float, rhs: Matrix3) -> Matrix3 {
        rhs * lhs
    }

    public static func * (lhs: Matrix3, rhs: Vec3) -> Vec3 {
        lhs.cx * rhs.x + lhs.cy * rhs.y + lhs.cz * rhs.z
    }

    public static func * (lhs: Matrix3, rhs: Matrix3) -> Matrix3 {
        Matrix3(
            cx: lhs * rhs.cx,
            cy: lhs * rhs.cy,
            cz: lhs * rhs.cz
        )
    }

    public static func / (lhs: Matrix3, rhs: Float) -> Matrix3 {
        Matrix3(cx: lhs.cx / rhs, cy: lhs.cy / rhs, cz: lhs.cz / rhs)
    }
}
