//
//  AppDelegate.swift
//  ShortCuts
//
//  Created by Xiupeng Ma on 8/5/19.
//  Copyright © 2019 Xiupeng Ma. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, MonitorDelegte {
    static func hasA11yPrivileges() -> Bool{
        let trusted = kAXTrustedCheckOptionPrompt.takeUnretainedValue()
        let privOptions = [trusted: true] as CFDictionary
        let accessEnabled = AXIsProcessTrustedWithOptions(privOptions)
        return accessEnabled
    }
    
    private let shortcutMonitor = ShortcutMonitor()
    private let shortcutStorage = ShortcutStorage()
    private var monitor: Monitor
    private let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    override init() {
        monitor = Monitor(shortcutMonitor: shortcutMonitor, shortcutStorage: shortcutStorage)
        super.init()
        monitor.delegate = self
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let iconImage = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        iconImage?.resizingMode = .stretch
        iconImage?.size = NSMakeSize(18.0, 18.0)
        
        if let button = statusItem.button {
          button.image = iconImage
          button.action = #selector(printQuote(_:))
        }
        
        constructMenu()
        initMonitor()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func printQuote(_ sender: Any?) {
      let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
      let quoteAuthor = "Mark Twain"
      
      print("\(quoteText) — \(quoteAuthor)")
    }
    
    func constructMenu() {
      let menu = NSMenu()

      menu.addItem(NSMenuItem(title: "Print Quote", action: #selector(AppDelegate.printQuote(_:)), keyEquivalent: "P"))
      menu.addItem(NSMenuItem.separator())
      menu.addItem(NSMenuItem(title: "Quit Quotes", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

      statusItem.menu = menu
    }
    
    func initMonitor() {
        if type(of: self).hasA11yPrivileges() {
            print("Has a11y privileges");
        } else {
            print("Has No privilesge");
            if !type(of: self).hasA11yPrivileges() {
                return
            }
        }
        
        shortcutMonitor.start()
        var flags = NSEvent.ModifierFlags.init();
        flags = flags.union(.command)
        flags = flags.union(.control)
        flags = flags.union(NSEvent.ModifierFlags.init(rawValue: 0x111))
        shortcutStorage.storeAssignmentModeStorage(Shortcut(keyCode: 7, flags: flags))
    }
    
    // Monitor Delegate
    func onEnteringAssignmentMode(fromMonitor: Monitor) {
       print("entering assignment mode")
    }

    func onExitAssignmentMode(withAssignedApplication application: Application, replacedApplication: Application?, withShortcut shortcut: Shortcut, fromMonitor: Monitor) {
       print("exiting assignment mode, assigned short cut \(shortcut) to application \(application.name)")
    }

    func onTriggerApplication(application: Application, byShortcut shortcut: Shortcut, fromMonitor monitor: Monitor) {
       print("triggered application \(application.name) with shortcut \(shortcut)")
    }

    func onConflictWithAssignmentShortcut(shortcut: Shortcut, fromMonitor: Monitor) {
       print("shortcut \(shortcut) conflicts with assignment shortcut")
    }

    func onFailedToFindRunningInstanceOfApplication(application: Application, withShortcut shortcut: Shortcut, fromMonitor: Monitor) {
       print("failed to find running instance of application \(application.name)")
    }
}
