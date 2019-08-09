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
    public var name: String
    public var runningInstance: NSRunningApplication?
    
    required init(identifier: String, name: String, runningInstance: NSRunningApplication?) {
        self.identifier = identifier
        self.name = name
        self.runningInstance = runningInstance
    }
    
    static func fromRunningApplication(runningApplication: NSRunningApplication) -> Application? {
        if let identifier = runningApplication.bundleIdentifier, let name = runningApplication.localizedName {
            return Application(identifier: identifier, name: name, runningInstance: runningApplication)
        }
        return nil
    }
}
