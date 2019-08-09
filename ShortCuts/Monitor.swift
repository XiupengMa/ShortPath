//
//  Monitor.swift
//  ShortCuts
//
//  Created by Xiupeng Ma on 8/8/19.
//  Copyright © 2019 Xiupeng Ma. All rights reserved.
//

import Foundation

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
    }
    
    func onShortcutDetected(_ shortcut: Shortcut, fromMonitor: ShortcutMonitor) {
        if inAssignmentMode {
            if shortcutStorage.isAssignmentModeShortcut(shortcut) {
                delegate?.onConflictWithAssignmentShortcut(shortcut: shortcut, fromMonitor: self)
            } else {
                let application = Application(identifier: "123", runningInstance: nil) // TODO: get current active application
                let oldApplication = shortcutStorage.getApplicationForShortcut(shortcut)
                delegate?.onExitAssignmentMode(withAssignedApplication: application, replacedApplication: oldApplication, withShortcut: shortcut, fromMonitor: self)
            }
            
            inAssignmentMode = false
            return
        } else {
            if shortcutStorage.isAssignmentModeShortcut(shortcut) {
                delegate?.onEnteringAssignmentMode(fromMonitor: self)
                inAssignmentMode = false
            } else if let application = shortcutStorage.getApplicationForShortcut(shortcut) {
                delegate?.onTriggerApplication(application: application, byShortcut: shortcut, fromMonitor: self)
            }
            return
        }
    }
}
