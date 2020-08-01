//
//  WindowSupport.swift
//  
//
//  Created by Vasilis Akoinoglou on 31/7/20.
//

#if canImport(AppKit)

import AppKit

public func launchSketch(_ view: SPSView) {
    let app                           = NSApplication.shared
    let menubar                       = NSMenu()
    let appMenuItem                   = NSMenuItem()
    let appMenu                       = NSMenu()
    let appName                       = ProcessInfo.processInfo.processName
    let quitTitle                     = "Quit \(appName)"
    let quitMenuItem                  = NSMenuItem(title: quitTitle, action: #selector(NSApplication.terminate), keyEquivalent: "q")
    let windowRect                    = view.bounds
    let styleMask: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, /*.resizable,*/ .fullSizeContentView]
    let window                        = NSWindow(contentRect: windowRect, styleMask: styleMask, backing: .buffered,  defer: false)

    app.setActivationPolicy(.regular)
    menubar.addItem(appMenuItem)
    app.mainMenu = menubar
    appMenu.addItem(quitMenuItem)
    appMenuItem.submenu = appMenu

    window.center()
    window.title = appName
    window.contentView = view
    window.makeKeyAndOrderFront(nil)
    app.run()
}

#endif
