import Foundation
import CoreGraphics


//MARK: - Context

public enum RenderProvider {
    case coregraphics, spritekit, scenekit
    var backend: Renderer {
        switch self {
        case .coregraphics: return ctx!
        case .spritekit: fatalError()
        case .scenekit: fatalError()
        }
    }
}

var renderProvider: RenderProvider = .coregraphics
var renderer: Renderer = renderProvider.backend

public var width: CGFloat {
    CGFloat(renderer.width)
}

public var height: CGFloat {
    CGFloat(renderer.height)
}

public func push() {
    renderer.push()
}

public func pop() {
    renderer.pop()
}

public func translate(_ x: CGFloat, _ y: CGFloat) {
    renderer.translate(x, y)
}

public func scale(_ x: CGFloat, _ y: CGFloat) {
    renderer.scale(x, y)
}

public func smooth() {
    renderer.smooth()
}

public func noSmooth() {
    renderer.noSmooth()
}

public func rotate(_ angle: CGFloat) {
    renderer.rotate(angle)
}

public func clear() {
    renderer.clear()
}

extension Sketch {
    // Views have their own rotate function. Make sure it uses our own.
    public func rotate(_ angle: CGFloat) {
        renderer.rotate(angle)
    }

    public func clear() {
        renderer.clear()
    }
}
