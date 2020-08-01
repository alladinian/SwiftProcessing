//
//  DisplayLink.swift
//  SwiftProcessing-Mac
//
//  Created by Vasilis Akoinoglou on 13/06/2019.
//

#if canImport(UIKit)
import UIKit
typealias DisplayLink = CADisplayLink
#endif

#if canImport(Cocoa)
import Cocoa

typealias DisplayLink = MacDisplayLink

class MacDisplayLink {
    let timer  : CVDisplayLink
    let source : DispatchSourceUserDataAdd
    var running : Bool { return CVDisplayLinkIsRunning(timer) }
    weak var target: SPSView?

    /**
     Creates a new DisplayLink that gets executed on the given queue

     - Parameters:
     - queue: Queue which will receive the callback calls
     */
    init?(onQueue queue: DispatchQueue = DispatchQueue.main, target: SPSView, selector: Selector) {
        // Source
        source = DispatchSource.makeUserDataAddSource(queue: queue)
        // Timer
        var timerRef : CVDisplayLink? = nil
        // Create timer
        var successLink = CVDisplayLinkCreateWithActiveCGDisplays(&timerRef)
        if let timer = timerRef {
            // Set Output
            successLink = CVDisplayLinkSetOutputCallback(timer, { (timer, currentTime, outputTime, _, _, sourceUnsafeRaw) -> CVReturn in
                    // Un-opaque the source
                    if let sourceUnsafeRaw = sourceUnsafeRaw {
                        // Update the value of the source, thus, triggering a handle call on the timer
                        let sourceUnmanaged = Unmanaged<DispatchSourceUserDataAdd>.fromOpaque(sourceUnsafeRaw)
                        sourceUnmanaged.takeUnretainedValue().add(data: 1)
                    }
                    return kCVReturnSuccess
            }, Unmanaged.passUnretained(source).toOpaque())

            guard successLink == kCVReturnSuccess else {
                NSLog("Failed to create timer with active display")
                return nil
            }

            // Connect to display
            successLink = CVDisplayLinkSetCurrentCGDisplay(timer, CGMainDisplayID())

            guard successLink == kCVReturnSuccess else {
                NSLog("Failed to connect to display")
                return nil
            }

            self.timer = timer
        } else {
            NSLog("Failed to create timer with active display")
            return nil
        }

        self.target = target

        // Timer setup
        source.setEventHandler { [weak self] in
            self?.target?.perform(selector)
        }

        start()
    }

    /// Starts the timer
    func start() {
        guard !running else { return }
        CVDisplayLinkStart(timer)
        source.resume()
    }

    /// Cancels the timer, can be restarted aftewards
    func cancel() {
        guard running else { return }
        CVDisplayLinkStop(timer)
        source.cancel()
    }

    var isPaused: Bool {
        get { !running }
        set { newValue ? start() : cancel() }
    }

    deinit {
        if running {
            cancel()
        }
    }
}

#endif
