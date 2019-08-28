//
//  ShortcutStorage.swift
//  ShortCuts
//
//  Created by Xiupeng Ma on 8/7/19.
//  Copyright © 2019 Xiupeng Ma. All rights reserved.
//

import Foundation
import AppKit

class ShortcutStorage {
    private var localStorage: [Shortcut: Application]
    private var assignmentModeShortcut: Shortcut?
    
    internal init() {
        localStorage = [Shortcut: Application]()
    }
    
    public func storeShortcut(_ shortcut: Shortcut, forApplication application: Application) {
        localStorage[shortcut] = application
    }
    
    public func getApplicationForShortcut(_ shortcut: Shortcut) -> Application? {
        return localStorage[shortcut]
    }
    
    public func removeShortcut(_ shortcut: Shortcut) {
        localStorage.removeValue(forKey: shortcut)
    }
    
    public func storeAssignmentModeStorage(_ shortcut: Shortcut) {
        assignmentModeShortcut = shortcut
    }
    
    public func isAssignmentModeShortcut(_ shortcut: Shortcut) -> Bool {
        return assignmentModeShortcut == shortcut
    }
    
    public func getAllShortcuts() -> [Shortcut: Application] {
        return localStorage
    }
}
