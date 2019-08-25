//
//  PopoverController.swift
//  ShortCuts
//
//  Created by Xiupeng Ma on 8/20/19.
//  Copyright © 2019 Xiupeng Ma. All rights reserved.
//

import Foundation
import AppKit

class PopoverController : NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    private var shortcutStorage: ShortcutStorage?
    @IBOutlet weak var appList: NSTableView!
    static func freshController() -> PopoverController {
        let identifier = NSStoryboard.SceneIdentifier("PopoverController")
        guard let viewcontroller = NSStoryboard.main?.instantiateController(withIdentifier: identifier) as? PopoverController else {
            fatalError("Couldn't find PopoverController")
        }
        return viewcontroller
    }
    
    override func viewDidLoad() {
        appList.dataSource = self;
        appList.delegate = self;
        print("viewDidLoad")
    }
    
    override func viewWillAppear() {
        appList.reloadData()
        print("viewDidAppear")
    }
    
    func setShortcutStorage(shortcutStorage: ShortcutStorage) {
        self.shortcutStorage = shortcutStorage
    }
    
    // NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        print("numberofrows: \(shortcutStorage?.getAllShortcuts().capacity ?? 0)")
        return shortcutStorage?.getAllShortcuts().count ?? 0
    }
    
    // NSTableViewDelegate
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let storage = shortcutStorage?.getAllShortcuts() {
            let array = Array(storage.keys)
            let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "appCell"), owner: self) as! AppCell
            
            cellView.setAppName(storage[array[row]]!.name)
            cellView.setShortcut(array[row].toString())
            return cellView
        }

        return nil
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 25.0
    }
    
}
