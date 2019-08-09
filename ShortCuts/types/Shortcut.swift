//
//  Shortcut.swift
//  ShortCuts
//
//  Created by Xiupeng Ma on 8/7/19.
//  Copyright © 2019 Xiupeng Ma. All rights reserved.
//

import Foundation
import AppKit

class Shortcut: Hashable {
    public var keyCode: UInt16
    public var flags: NSEvent.ModifierFlags
    
    required init(keyCode: UInt16, flags: NSEvent.ModifierFlags) {
        self.keyCode = keyCode
        self.flags = flags
    }

    public static func fromKeydownEvent(_ event: NSEvent) -> Shortcut {
        return self.init(keyCode: event.keyCode, flags: event.modifierFlags)
    }
    
    static func == (lhs: Shortcut, rhs: Shortcut) -> Bool {
        return lhs.keyCode == rhs.keyCode && lhs.flags == rhs.flags;
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine("\(keyCode)_\(flags)")
    }
}
