//
//  HeaderView.swift
//  SlidesMagic
//
//  Created by ATM on 2017/11/6.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Cocoa

class HeaderView: NSView {

    @IBOutlet weak var sectionTitle: NSTextField!
    
    @IBOutlet weak var imageCount: NSTextField!
    
    
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        
        self.layer?.backgroundColor = NSColor.lightGray.cgColor
//        self.setNeedsDisplay(dirtyRect)
    }
    
}
