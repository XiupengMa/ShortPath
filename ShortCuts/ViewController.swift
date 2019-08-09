//
//  ViewController.swift
//  ShortCuts
//
//  Created by Xiupeng Ma on 8/5/19.
//  Copyright © 2019 Xiupeng Ma. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    private let shortcutMonitor = ShortcutMonitor()
    private let shortcutStorage = ShortcutStorage()
    private var monitor: Monitor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if type(of: self).hasA11yPrivileges() {
            print("Has a11y privileges");
        } else {
            print("Has No privilesge");
            if !type(of: self).hasA11yPrivileges() {
                return
            }
        }
        
        if monitor == nil {
            monitor = Monitor(shortcutMonitor: shortcutMonitor, shortcutStorage: shortcutStorage)
            monitor = monitor!
        }
        
        shortcutMonitor.start()
        var flags = NSEvent.ModifierFlags.init();
        flags = flags.union(.command)
        flags = flags.union(.control)
        flags = flags.union(NSEvent.ModifierFlags.init(rawValue: 0x111))
        shortcutStorage.storeAssignmentModeStorage(Shortcut(keyCode: 7, flags: flags))
//
//        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { (event) in
//            if event.modifierFlags.contains(.command) &&
//                event.modifierFlags.contains(.control)
//                {
//                    if event.keyCode == 38 {
//                        self.getRunningApplications("chrome")
//                    } else if event.keyCode == 40 {
//                        self.getRunningApplications("youdao")
//                    } else if event.keyCode == 37 {
//                        self.getRunningApplications("mpv")
//                    }            }
//        }

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    static func hasA11yPrivileges() -> Bool{
        let trusted = kAXTrustedCheckOptionPrompt.takeUnretainedValue()
        let privOptions = [trusted: true] as CFDictionary
        let accessEnabled = AXIsProcessTrustedWithOptions(privOptions)
        return accessEnabled
    }
    
    func getRunningApplications(_ key: String) {
        let runningApps = NSWorkspace.shared.runningApplications
        var chrome: NSRunningApplication?
        for app in runningApps {
            if app.localizedName?.lowercased().contains(key) ?? false {
                chrome = app
                break
            }
        }
//        if let c = chrome {
//            NSWorkspace.shared.activate
//            NSWorkspace.shared.frontmostApplication(chrome)
//        }
        if let c = chrome {
//            print(c)
//            print(c.activate(options: .activateIgnoringOtherApps))
            c.activate(options: .activateIgnoringOtherApps)
            if c.isHidden {
                c.unhide()
            }
        }
    }
}

