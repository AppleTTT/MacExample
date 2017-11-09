//
//  BookCellView.swift
//  BookShop
//
//  Created by ATM on 2017/11/9.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Cocoa

class BookCellView: NSTableCellView {

    @IBOutlet weak var bookTitle: NSTextField!
    
    @IBOutlet weak var coverImage: NSImageView!
    
    
    override var backgroundStyle: NSView.BackgroundStyle {
        didSet {
            switch backgroundStyle {
            case .dark:
                bookTitle.textColor = NSColor.white
            default:
                bookTitle.textColor = NSColor.black
            }
        }
    }
    
    
    
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
