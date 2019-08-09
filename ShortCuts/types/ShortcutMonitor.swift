//
//  ShortcutMonitor.swift
//  ShortCuts
//
//  Created by Xiupeng Ma on 8/7/19.
//  Copyright © 2019 Xiupeng Ma. All rights reserved.
//

import Foundation
import AppKit

protocol ShortcutMonitorDelegate {
    func onShortcutDetected(_ shortcut: Shortcut, fromMonitor: ShortcutMonitor)
}

class ShortcutMonitor {
    private var isMonitoring = false
    private var globalMonitor: Any?
    private var localMonitor: Any?
    public var delegate: ShortcutMonitorDelegate?
    
    public func start() {
        if isMonitoring {
            return;
        }
        
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown, handler: self.onKeyDown)
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (event) -> NSEvent? in
            self.onKeyDown(event: event);
            return event;
        }
        
        isMonitoring = true
    }
    
    public func stop() {
        if !isMonitoring {
            return
        }
        
        if let globalMonitor = globalMonitor {
            NSEvent.removeMonitor(globalMonitor)
        }
        if let localMonitor = localMonitor {
            NSEvent.removeMonitor(localMonitor)
        }
        
        isMonitoring = false
    }
    
    private func onKeyDown(event: NSEvent) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.onShortcutDetected(Shortcut.fromKeydownEvent(event), fromMonitor: self);
    }
}
