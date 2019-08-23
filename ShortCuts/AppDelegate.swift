//
//  AppDelegate.swift
//  ShortCuts
//
//  Created by Xiupeng Ma on 8/5/19.
//  Copyright © 2019 Xiupeng Ma. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, MonitorDelegte, NSMenuDelegate {
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
    private let popover = NSPopover()
    private let popoverController = PopoverController.freshController()
    
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
            button.action = #selector(togglePopover(_:))
        }
        
        popoverController.setShortcutStorage(shortcutStorage: shortcutStorage)
        popover.contentViewController = popoverController
        popover.behavior = NSPopover.Behavior.transient;
        
        initMonitor()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationWillResignActive(_ notification: Notification) {
        popover.close()
    }

    @objc func togglePopover(_ sender: Any?) {
      if popover.isShown {
        closePopover(sender: sender)
      } else {
        showPopover(sender: sender)
      }
    }
    
    func showPopover(sender: Any?) {
      if let button = statusItem.button {
        NSApp.activate(ignoringOtherApps: true)
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
      }
    }

    func closePopover(sender: Any?) {
      popover.performClose(sender)
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
        shortcutStorage.storeAssignmentModeStorage(Shortcut(keyCode: 7, flags: flags, characters: "x"))
    }
    
    func getApplicationMenuItems() -> [NSMenuItem] {
        let runningApplications = NSWorkspace.shared.runningApplications;
        
        var hasRunningInstance = [String: Bool]()
        
        for runningApplication in runningApplications {
            if let bundleName = runningApplication.bundleIdentifier {
                hasRunningInstance[bundleName] = true
            }
        }
        
        return shortcutStorage.getAllShortcuts().map { (key: Shortcut, value: Application) -> NSMenuItem in
            let item = NSMenuItem(title: value.name + " " + key.toString(), action: hasRunningInstance[value.identifier, default: false] ? #selector(noop) : nil, keyEquivalent: "")
            return item
        }
    }
    
    @objc func noop() {
        
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
    
    // NSMenu Delegate
    func menuWillOpen(_ menu: NSMenu) {
//        menu.removeAllItems()
//
//        menu.addItem(NSMenuItem(title: "Print Quote", action: #selector(AppDelegate.printQuote(_:)), keyEquivalent: "P"))
//        menu.addItem(NSMenuItem.separator())
//        getApplicationMenuItems().forEach { (item) in
//            menu.addItem(item)
//        }
//        menu.addItem(NSMenuItem.separator())
//        menu.addItem(NSMenuItem(title: "Quit Quotes", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    }
}
