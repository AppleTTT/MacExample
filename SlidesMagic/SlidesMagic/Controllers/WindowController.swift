//
//  WindowController.swift
//  SlidesMagic
//
//  Created by ATM on 2017/11/6.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        if let window = window, let screen = NSScreen.main {
            let screenRect = screen.visibleFrame
            window.setFrame(NSRect.init(x: 100, y: 50, width: screenRect.width / 2, height: screenRect.height / 2), display: true)
            
        }
    }
    
    @IBAction func openAnotherFolder(sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.showsHiddenFiles = false
        
        openPanel.beginSheetModal(for: window!) { response in
            guard response.rawValue == NSFileHandlingPanelOKButton else {
                return
            }

            let viewcontroller = self.contentViewController as? ViewController
            if let vc = viewcontroller, let url = openPanel.url {
                vc.loadDataFor(url)
            }
            
        }
        
        
        
    }
    
    
    
    

}
