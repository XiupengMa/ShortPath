//
//  AppCell.swift
//  ShortCuts
//
//  Created by Xiupeng Ma on 8/24/19.
//  Copyright © 2019 Xiupeng Ma. All rights reserved.
//

import Foundation
import AppKit

protocol AppCellDelegate {
    func onDelete(cell: AppCell) -> Void
}

class AppCell: NSTableCellView {
    public var delegate: AppCellDelegate?
    private var app: Application?
    private var shortcut: Shortcut?
    
    @IBOutlet weak var appName: NSTextField!
    @IBOutlet weak var shortcutName: NSTextField!
    
    public func setApp(_ app: Application) {
        self.app = app
        self.appName.stringValue = app.name
    }
    
    public func setShortcut(_ shortcut: Shortcut) {
        self.shortcut = shortcut
        self.shortcutName.stringValue = shortcut.toString()
    }
    
    public func getShortcut() -> Shortcut? {
        return shortcut
    }

    @IBAction func onDelete(_ sender: Any) {
        delegate?.onDelete(cell: self)
    }
}
