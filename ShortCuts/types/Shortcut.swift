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
    public var characters: String?
    
    required init(keyCode: UInt16, flags: NSEvent.ModifierFlags, characters: String?) {
        self.keyCode = keyCode
        self.flags = flags
        self.characters = characters
    }

    public static func fromKeydownEvent(_ event: NSEvent) -> Shortcut {
        return self.init(keyCode: event.keyCode, flags: event.modifierFlags, characters: event.charactersIgnoringModifiers)
    }
    
    static func == (lhs: Shortcut, rhs: Shortcut) -> Bool {
        return lhs.keyCode == rhs.keyCode && lhs.flags == rhs.flags;
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine("\(keyCode)_\(flags)")
    }
    
    func toString() -> String {
        var str = "";
        if flags.contains(.control) {
            str += "\u{2303}"
        }
        if flags.contains(.option) {
            str += "\u{2325}"
        }
        if flags.contains(.shift) {
            str += "\u{21e7}"
        }
        if flags.contains(.command) {
            str += "\u{2318}"
        }
        
        return str + (characters ?? "").uppercased()
    }
}
