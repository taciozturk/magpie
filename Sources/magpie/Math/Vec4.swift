//
//  Vec4.swift
//  magpie
//
//  Created by Taci Öztürk on 28.11.2026.
//

import Foundation

public struct Vec4: Equatable, Hashable, Codable, Sendable {
    public var x: Float = 0
    public var y: Float = 0
    public var z: Float = 0
    public var w: Float = 0

    public var lengthSquared: Float {
        dot(self)
    }

    public var length: Float {
        lengthSquared.squareRoot()
    }

    public var normalized: Vec4 {
        var copy = self
        copy.normalize()
        return copy
    }

    public init(x: Float, y: Float, z: Float, w: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }

    public init(_ x: Float, _ y: Float, _ z: Float, _ w: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }

    public init(_ value: Float) {
        self.x = value
        self.y = value
        self.z = value
        self.w = value
    }

    public static let zero = Vec4(x: 0, y: 0, z: 0, w: 0)
    public static let one = Vec4(x: 1, y: 1, z: 1, w: 1)

    public static prefix func - (v: Vec4) -> Vec4 {
        Vec4(x: -v.x, y: -v.y, z: -v.z, w: -v.w)
    }

    public static func + (lhs: Vec4, rhs: Vec4) -> Vec4 {
        Vec4(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z, w: lhs.w + rhs.w)
    }

    public static func - (lhs: Vec4, rhs: Vec4) -> Vec4 {
        Vec4(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z, w: lhs.w - rhs.w)
    }

    public static func * (lhs: Vec4, rhs: Float) -> Vec4 {
        Vec4(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs, w: lhs.w * rhs)
    }

    public static func * (lhs: Float, rhs: Vec4) -> Vec4 {
        rhs * lhs
    }

    public static func / (lhs: Vec4, rhs: Float) -> Vec4 {
        Vec4(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs, w: lhs.w / rhs)
    }

    public static func += (lhs: inout Vec4, rhs: Vec4) {
        lhs = lhs + rhs
    }

    public static func -= (lhs: inout Vec4, rhs: Vec4) {
        lhs = lhs - rhs
    }

    public static func *= (lhs: inout Vec4, rhs: Float) {
        lhs = lhs * rhs
    }

    public static func /= (lhs: inout Vec4, rhs: Float) {
        lhs = lhs / rhs
    }

    public mutating func normalize() {
        let len = length
        guard len > 0 else { return }
        x /= len
        y /= len
        z /= len
        w /= len
    }

    public mutating func addScalar(value: Float) {
        self.x += value
        self.y += value
        self.z += value
        self.w += value
    }

    public mutating func subtractScalar(value: Float) {
        self.x -= value
        self.y -= value
        self.z -= value
        self.w -= value
    }

    public func dot(_ other: Vec4) -> Float {
        x * other.x + y * other.y + z * other.z + w * other.w
    }

    public func reflect(_ normal: Vec4) -> Vec4 {
        let proj = self.dot(normal)
        return self - (2 * proj * normal)
    }

    public func distanceSquared(to other: Vec4) -> Float {
        (self - other).lengthSquared
    }

    public func distance(to other: Vec4) -> Float {
        (self - other).length
    }

    // angle relative to origin
    public func angle(between other: Vec4) -> Float {
        let dotProduct = self.dot(other)
        let lengthsProduct = self.length * other.length
        guard lengthsProduct > 0 else { return 0 }
        let cosTheta = dotProduct / lengthsProduct
        return acos(cosTheta)
    }

}

extension Vec4: CustomStringConvertible {
    public var description: String { "[x:\(x), y:\(y), z:\(z), w:\(w)]" }
}
