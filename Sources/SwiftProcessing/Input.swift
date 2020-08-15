//
//  Input.swift
//  
//
//  Created by Vasilis Akoinoglou on 30/7/20.
//

import Foundation

#if os(macOS)
import AppKit

//MARK: - Mouse
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
        super.mouseEntered(with: event)
        let location = event.locationInWindow
        mouseLocation = convert(location, from: nil)
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        let location = event.locationInWindow
        mouseLocation = convert(location, from: nil)
    }

    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        let location = event.locationInWindow
        mouseLocation = convert(location, from: nil)
        mouseMoved()
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        mouseButton = LEFT
        mousePressed()
    }

    override func rightMouseDown(with event: NSEvent) {
        super.rightMouseDown(with: event)
        mouseButton = RIGHT
        mousePressed()
    }

    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        mouseButton = LEFT
        mouseClicked()
        mouseReleased()
    }

    override func rightMouseUp(with event: NSEvent) {
        super.rightMouseUp(with: event)
        mouseButton = RIGHT
        mouseClicked()
        mouseReleased()
    }

    override func otherMouseDown(with event: NSEvent) {
        super.otherMouseDown(with: event)
        mouseButton = CENTER
        mousePressed()
    }

    override func otherMouseUp(with event: NSEvent) {
        super.otherMouseUp(with: event)
        mouseButton = CENTER
        mouseClicked()
        mouseReleased()
    }

    override func scrollWheel(with event: NSEvent) {
        super.scrollWheel(with: event)
        mouseWheel(offset: event.scrollingDeltaY)
    }

    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        mouseButton = LEFT
        mouseDragged()
    }

    override func rightMouseDragged(with event: NSEvent) {
        super.rightMouseDragged(with: event)
        mouseButton = RIGHT
        mouseDragged()
    }

    override func otherMouseDragged(with event: NSEvent) {
        super.otherMouseDragged(with: event)
        mouseButton = CENTER
        mouseDragged()
    }

    override func updateTrackingAreas() {
        self.addTrackingArea(NSTrackingArea(rect: self.bounds,
                                            options: [.mouseEnteredAndExited, .mouseMoved, .activeInKeyWindow],
                                            owner: self,
                                            userInfo: nil))
    }

}

//MARK: - Keyboard
public extension SPSView {

    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
        key = event.characters?.first
        keyPressed()
    }

    override func keyUp(with event: NSEvent) {
        super.keyUp(with: event)
        key = event.characters?.first
        keyReleased()
    }

}

#endif
