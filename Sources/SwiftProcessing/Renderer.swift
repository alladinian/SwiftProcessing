//
//  Renderer.swift
//  
//
//  Created by Vasilis Akoinoglou on 28/7/20.
//

import Foundation
import CoreGraphics

#if canImport(AppKit)
import AppKit
public typealias View      = NSView
public typealias Slider    = NSSlider
public typealias StackView = NSStackView
#elseif canImport(UIKit)
import UIKit
public typealias View      = UIView
public typealias Slider    = UISlider
public typealias StackView = UIStackView
#endif

var ctx: CGContext? {
    #if canImport(AppKit)
    return NSGraphicsContext.current?.cgContext
    #elseif canImport(UIKit)
    return UIGraphicsGetCurrentContext()
    #endif
}

public protocol Renderer {}

open class SPSView : View, Renderer {

    #if os(macOS)
    public override var isFlipped: Bool { return true }

    internal var previousMouseLocation: CGPoint = .zero
    internal var mouseLocation: CGPoint = .zero {
        willSet {
            previousMouseLocation = mouseLocation
        }
    }

    internal var mouseButton: MouseButton = .none

    public enum MouseButton: Int {
        case none, left, right, center
    }

    public let NONE   = MouseButton.none
    public let LEFT   = MouseButton.left
    public let RIGHT  = MouseButton.right
    public let CENTER = MouseButton.center

    open func mousePressed() {}
    open func mouseClicked() {}
    open func mouseReleased() {}
    open func mouseWheel(offset: CGFloat) {}
    open func mouseMoved() {}
    open func mouseDragged() {}

    #endif

    fileprivate var link: DisplayLink?

    fileprivate let stackView = StackView()

    public var width: CGFloat { bounds.width }
    public var height: CGFloat { bounds.height }

    #if os(iOS)
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    #endif

    #if os(macOS)
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    #endif

    public init(size: CGSize) {
        super.init(frame: .init(x: 0, y: 0, width: size.width, height: size.height))
        commonInit()
    }

    required public init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        commonInit()
    }

    public func commonInit() {

        link = DisplayLink(target: self, selector: #selector(step))

        #if os(iOS)
        link?.add(to: .current, forMode: .default)
        stackView.axis = .vertical
        #endif

        #if os(macOS)
        wantsLayer = true
        stackView.orientation = .vertical
        #endif

        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 200).isActive = true

        setup()
    }

    //MARK:- Drawing

    open func setup() {}

    open func draw() {}

    #if os(iOS)
    open override func draw(_ rect: CGRect) {
        guard let _ = ctx else { return }
        draw()
    }
    #endif

    #if os(macOS)
    public override func draw(_ dirtyRect: NSRect) {
        guard let _ = ctx else { return }
        draw()
    }
    #endif

    public func createSlider(_ min: CGFloat, _ max: CGFloat, _ default: CGFloat, _ step: CGFloat) -> Slider {
        #if os(macOS)
        let slider = Slider(value: Double(`default`), minValue: Double(min), maxValue: Double(max), target: self, action: #selector(sliderDidChange))
        #endif

        #if os(iOS)
        let slider = Slider(frame: .zero)
        slider.addTarget(self, action: #selector(sliderDidChange), for: .valueChanged)
        #endif

        slider.translatesAutoresizingMaskIntoConstraints = false
        stackView.insertArrangedSubview(slider, at: stackView.arrangedSubviews.count)
        return slider
    }

    @objc func sliderDidChange(_ sender: Slider) {

    }

    public func loop() {
        link?.isPaused = false
    }

    public func noLoop() {
        link?.isPaused = true
    }

    @objc public func step() {
        #if os(iOS)
        setNeedsDisplay()
        #endif

        #if os(macOS)
        needsDisplay = true
        #endif
    }
}

