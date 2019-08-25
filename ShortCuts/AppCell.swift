//
//  AppCell.swift
//  ShortCuts
//
//  Created by Xiupeng Ma on 8/24/19.
//  Copyright © 2019 Xiupeng Ma. All rights reserved.
//

import Foundation
import AppKit

class AppCell: NSTableCellView {
    @IBOutlet weak var appName: NSTextField!
    @IBOutlet weak var shortcut: NSTextField!
    
    public func setAppName(_ appName: String) {
        self.appName.stringValue = appName
    }
    
    public func setShortcut(_ shortcut: String) {
        self.shortcut.stringValue = shortcut
    }
}
