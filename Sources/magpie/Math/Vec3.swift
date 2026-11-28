//
//  Vec3.swift
//  magpie
//
//  Created by Taci Öztürk on 28.11.2026.
//

import Foundation

public struct Vec3: Equatable, Hashable, Codable, Sendable {
    public var x: Float = 0
    public var y: Float = 0
    public var z: Float = 0

    public var lengthSquared: Float {
        dot(self)
    }

    public var length: Float {
        lengthSquared.squareRoot()
    }

    public var normalized: Vec3 {
        var copy = self
        copy.normalize()
        return copy
    }

    public init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }

    public init(_ x: Float, _ y: Float, _ z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }

    public init(_ value: Float) {
        self.x = value
        self.y = value
        self.z = value
    }

    public static let zero = Vec3(x: 0, y: 0, z: 0)
    public static let one = Vec3(x: 1, y: 1, z: 1)

    public static prefix func - (v: Vec3) -> Vec3 {
        Vec3(x: -v.x, y: -v.y, z: -v.z)
    }

    public static func + (lhs: Vec3, rhs: Vec3) -> Vec3 {
        Vec3(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    public static func - (lhs: Vec3, rhs: Vec3) -> Vec3 {
        Vec3(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }

    public static func * (lhs: Vec3, rhs: Float) -> Vec3 {
        Vec3(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }

    public static func * (lhs: Float, rhs: Vec3) -> Vec3 {
        rhs * lhs
    }

    public static func / (lhs: Vec3, rhs: Float) -> Vec3 {
        Vec3(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }

    public static func += (lhs: inout Vec3, rhs: Vec3) {
        lhs = lhs + rhs
    }

    public static func -= (lhs: inout Vec3, rhs: Vec3) {
        lhs = lhs - rhs
    }

    public static func *= (lhs: inout Vec3, rhs: Float) {
        lhs = lhs * rhs
    }

    public static func /= (lhs: inout Vec3, rhs: Float) {
        lhs = lhs / rhs
    }

    public mutating func normalize() {
        let len = length
        guard len > 0 else { return }
        x /= len
        y /= len
        z /= len
    }

    public mutating func addScalar(value: Float) {
        self.x += value
        self.y += value
        self.z += value
    }

    public mutating func subtractScalar(value: Float) {
        self.x -= value
        self.y -= value
        self.z -= value
    }

    public func dot(_ other: Vec3) -> Float {
        x * other.x + y * other.y + z * other.z
    }

    public func reflect(_ normal: Vec3) -> Vec3 {
        let proj = self.dot(normal)
        return self - (2 * proj * normal)
    }

    public func distanceSquared(to other: Vec3) -> Float {
        (self - other).lengthSquared
    }

    public func distance(to other: Vec3) -> Float {
        (self - other).length
    }

    // angle relative to origin
    public func angle(between other: Vec3) -> Float {
        let dotProduct = self.dot(other)
        let lengthsProduct = self.length * other.length
        guard lengthsProduct > 0 else { return 0 }
        let cosTheta = dotProduct / lengthsProduct
        return acos(cosTheta)
    }

    /*
        cross product formula
        𝐚×b =   𝑎𝑦𝑏𝑧−𝑎𝑧𝑏𝑦
                𝑎𝑧𝑏𝑥−𝑎𝑥𝑏𝑧
                𝑎𝑥𝑏𝑦−𝑎𝑦𝑏𝑥
    */
    public func cross(_ other: Vec3) -> Vec3 {
        Vec3(
            x: (self.y * other.z) - (self.z * other.y),
            y: (self.z * other.x) - (self.x * other.y),
            z: (self.x * other.y) - (self.y * other.x)
        )
    }

}

extension Vec3: CustomStringConvertible {
    public var description: String { "[x:\(x), y:\(y), z:\(z)]" }
}

