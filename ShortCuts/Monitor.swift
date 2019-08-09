//
//  Monitor.swift
//  ShortCuts
//
//  Created by Xiupeng Ma on 8/8/19.
//  Copyright © 2019 Xiupeng Ma. All rights reserved.
//

import Foundation
import AppKit

protocol MonitorDelegte {
    func onEnteringAssignmentMode(fromMonitor: Monitor)
    func onExitAssignmentMode(withAssignedApplication application: Application, replacedApplication: Application?, withShortcut shortcut: Shortcut, fromMonitor: Monitor)
    func onTriggerApplication(application: Application, byShortcut shortcut: Shortcut, fromMonitor monitor: Monitor)
    func onConflictWithAssignmentShortcut(shortcut: Shortcut, fromMonitor: Monitor)
}

class Monitor: ShortcutMonitorDelegate {
    private let shortcutMonitor: ShortcutMonitor;
    private let shortcutStorage: ShortcutStorage;
    private var inAssignmentMode: Bool
    public var delegate: MonitorDelegte?
    
    internal init(shortcutMonitor: ShortcutMonitor, shortcutStorage: ShortcutStorage) {
        self.shortcutMonitor = shortcutMonitor
        self.shortcutStorage = shortcutStorage
        self.inAssignmentMode = false
        
        self.shortcutMonitor.delegate = self
    }
    
    func onShortcutDetected(_ shortcut: Shortcut, fromMonitor: ShortcutMonitor) {
        if inAssignmentMode {
            if shortcutStorage.isAssignmentModeShortcut(shortcut) {
                delegate?.onConflictWithAssignmentShortcut(shortcut: shortcut, fromMonitor: self)
            } else {
                let application = getActiveApplication()
                if let application = application {
                    let oldApplication = shortcutStorage.getApplicationForShortcut(shortcut)
                    shortcutStorage.storeShortcut(shortcut, forApplication: application)
                    delegate?.onExitAssignmentMode(withAssignedApplication: application, replacedApplication: oldApplication, withShortcut: shortcut, fromMonitor: self)
                } else {
                    print("didn't get valid application") // TODO: better error handling
                }
            }
            
            inAssignmentMode = false
            return
        } else {
            if shortcutStorage.isAssignmentModeShortcut(shortcut) {
                delegate?.onEnteringAssignmentMode(fromMonitor: self)
                inAssignmentMode = true
            } else if let application = shortcutStorage.getApplicationForShortcut(shortcut) {
                // TODO: move
                if let app = application.runningInstance {
                    app.activate(options: .activateIgnoringOtherApps)
                    if app.isHidden {
                        app.unhide()
                    }
                }
                delegate?.onTriggerApplication(application: application, byShortcut: shortcut, fromMonitor: self)
            }
            return
        }
    }
    
    func getActiveApplication() -> Application? {
        guard let runningApplication = NSWorkspace.shared.frontmostApplication else {
            return nil
        }
        
        return Application.fromRunningApplication(runningApplication: runningApplication)
    }
}
