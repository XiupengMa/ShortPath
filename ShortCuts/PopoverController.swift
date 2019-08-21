//
//  PopoverController.swift
//  ShortCuts
//
//  Created by Xiupeng Ma on 8/20/19.
//  Copyright © 2019 Xiupeng Ma. All rights reserved.
//

import Foundation
import AppKit

class PopoverController : NSViewController {
    static func freshController() -> PopoverController {
        let identifier = NSStoryboard.SceneIdentifier("PopoverController")
        guard let viewcontroller = NSStoryboard.main?.instantiateController(withIdentifier: identifier) as? PopoverController else {
            fatalError("Couldn't find PopoverController")
        }
        return viewcontroller
    }
}
