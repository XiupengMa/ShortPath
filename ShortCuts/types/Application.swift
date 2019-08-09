//
//  Application.swift
//  ShortCuts
//
//  Created by Xiupeng Ma on 8/8/19.
//  Copyright © 2019 Xiupeng Ma. All rights reserved.
//

import Foundation
import AppKit

class Application {
    public var identifier: String
    public var runningInstance: NSRunningApplication?
    
    internal init(identifier: String, runningInstance: NSRunningApplication?) {
        self.identifier = identifier
        self.runningInstance = runningInstance
    }
}
