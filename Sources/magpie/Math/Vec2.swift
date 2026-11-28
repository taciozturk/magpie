//
//  Vector2D.swift
//  magpie
//
//  Created by Taci Öztürk on 28.11.2026.
//

import Foundation

public struct Vec2: Equatable, Hashable, Codable, Sendable {
    public var x: Float = 0
    public var y: Float = 0

    public var lengthSquared: Float {
        dot(self)
    }

    public var length: Float {
        lengthSquared.squareRoot()
    }

    public var normalized: Vec2 {
        var copy = self
        copy.normalize()
        return copy
    }

    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }

    public init(_ x: Float, _ y: Float) {
        self.x = x
        self.y = y
    }

    public init(_ value: Float) {
        self.x = value
        self.y = value
    }

    public static let zero = Vec2(x: 0, y: 0)
    public static let one = Vec2(x: 1, y: 1)

    public static prefix func - (v: Vec2) -> Vec2 {
        Vec2(x: -v.x, y: -v.y)
    }

    public static func + (lhs: Vec2, rhs: Vec2) -> Vec2 {
        Vec2(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func - (lhs: Vec2, rhs: Vec2) -> Vec2 {
        Vec2(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    public static func * (lhs: Vec2, rhs: Float) -> Vec2 {
        Vec2(x: lhs.x * rhs, y: lhs.y * rhs)
    }

    public static func * (lhs: Float, rhs: Vec2) -> Vec2 {
        rhs * lhs
    }

    public static func / (lhs: Vec2, rhs: Float) -> Vec2 {
        Vec2(x: lhs.x / rhs, y: lhs.y / rhs)
    }

    public static func += (lhs: inout Vec2, rhs: Vec2) {
        lhs = lhs + rhs
    }

    public static func -= (lhs: inout Vec2, rhs: Vec2) {
        lhs = lhs - rhs
    }

    public static func *= (lhs: inout Vec2, rhs: Float) {
        lhs = lhs * rhs
    }

    public static func /= (lhs: inout Vec2, rhs: Float) {
        lhs = lhs / rhs
    }

    public mutating func normalize() {
        let len = length
        guard len > 0 else { return }
        x /= len
        y /= len
    }

    public mutating func addScalar(value: Float) {
        self.x += value
        self.y += value
    }

    public mutating func subtractScalar(value: Float) {
        self.x -= value
        self.y -= value
    }

    public func dot(_ other: Vec2) -> Float {
        x * other.x + y * other.y
    }

    public func reflect(_ normal: Vec2) -> Vec2 {
        let proj = self.dot(normal)
        return self - (2 * proj * normal)
    }

    public func distanceSquared(to other: Vec2) -> Float {
        (self - other).lengthSquared
    }

    public func distance(to other: Vec2) -> Float {
        (self - other).length
    }

    // angle relative to origin
    public func angle(between other: Vec2) -> Float {
        let dotProduct = self.dot(other)
        let lengthsProduct = self.length * other.length
        guard lengthsProduct > 0 else { return 0 }
        let cosTheta = dotProduct / lengthsProduct
        return acos(cosTheta)
    }

    public func cross(_ other: Vec2) -> Float {
        self.x * other.y - self.y * other.x
    }

}

extension Vec2: CustomStringConvertible {
    public var description: String { "[x:\(x), y:\(y)]" }
}
