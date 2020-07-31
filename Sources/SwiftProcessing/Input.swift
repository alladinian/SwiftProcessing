//
//  Input.swift
//  
//
//  Created by Vasilis Akoinoglou on 30/7/20.
//

import Foundation

#if os(macOS)
import AppKit

public extension SPSView {

    var pmouseX: CGFloat {
        previousMouseLocation.x
    }

    var pmouseY: CGFloat {
        previousMouseLocation.y
    }

    var mouseX: CGFloat {
        mouseLocation.x
    }

    var mouseY: CGFloat {
        mouseLocation.y
    }

    override func mouseEntered(with event: NSEvent) {
        let location = event.locationInWindow
        mouseLocation = convert(location, from: nil)
    }

    override func mouseExited(with event: NSEvent) {
        let location = event.locationInWindow
        mouseLocation = convert(location, from: nil)
    }

    override func mouseMoved(with event: NSEvent) {
        let location = event.locationInWindow
        mouseLocation = convert(location, from: nil)
        mouseMoved()
    }
    
    override func mouseDown(with event: NSEvent) {
        mouseButton = LEFT
        mousePressed()
    }

    override func rightMouseDown(with event: NSEvent) {
        mouseButton = RIGHT
        mousePressed()
    }

    override func mouseUp(with event: NSEvent) {
        mouseButton = LEFT
        mouseClicked()
        mouseReleased()
    }

    override func rightMouseUp(with event: NSEvent) {
        mouseButton = RIGHT
        mouseClicked()
        mouseReleased()
    }

    override func otherMouseDown(with event: NSEvent) {
        mouseButton = CENTER
        mousePressed()
    }

    override func otherMouseUp(with event: NSEvent) {
        mouseButton = CENTER
        mouseClicked()
        mouseReleased()
    }

    override func scrollWheel(with event: NSEvent) {
        mouseWheel(offset: event.scrollingDeltaY)
    }

    override func mouseDragged(with event: NSEvent) {
        mouseButton = LEFT
        mouseDragged()
    }

    override func rightMouseDragged(with event: NSEvent) {
        mouseButton = RIGHT
        mouseDragged()
    }

    override func otherMouseDragged(with event: NSEvent) {
        mouseButton = CENTER
        mouseDragged()
    }

}

#endif
