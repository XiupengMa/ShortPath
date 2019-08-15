//
//  ViewController.swift
//  ShortCuts
//
//  Created by Xiupeng Ma on 8/5/19.
//  Copyright © 2019 Xiupeng Ma. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, MonitorDelegte {
    static func hasA11yPrivileges() -> Bool{
        let trusted = kAXTrustedCheckOptionPrompt.takeUnretainedValue()
        let privOptions = [trusted: true] as CFDictionary
        let accessEnabled = AXIsProcessTrustedWithOptions(privOptions)
        return accessEnabled
    }
    
    private let shortcutMonitor = ShortcutMonitor()
    private let shortcutStorage = ShortcutStorage()
    private var monitor: Monitor
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        monitor = Monitor(shortcutMonitor: shortcutMonitor, shortcutStorage: shortcutStorage)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        monitor.delegate = self
    }
    
    required init?(coder: NSCoder) {
        monitor = Monitor(shortcutMonitor: shortcutMonitor, shortcutStorage: shortcutStorage)
        super.init(coder:coder)
        monitor.delegate = self
    }
    
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
        
        shortcutMonitor.start()
        var flags = NSEvent.ModifierFlags.init();
        flags = flags.union(.command)
        flags = flags.union(.control)
        flags = flags.union(NSEvent.ModifierFlags.init(rawValue: 0x111))
        shortcutStorage.storeAssignmentModeStorage(Shortcut(keyCode: 7, flags: flags))
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
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

