//
//  CollectionViewItem.swift
//  SlidesMagic
//
//  Created by ATM on 2017/11/6.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {
    
    var imageFile: ImageFile? {
        didSet {
            guard isViewLoaded else {
                return
            }
            if let imageFile = imageFile {
                imageView?.image = imageFile.thumbnail
                textField?.stringValue = imageFile.fileName
            }else {
                imageView?.image = nil
                textField?.stringValue = ""
            }
        }
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
        
        
        view.layer?.borderWidth = 0.0
        view.layer?.borderColor = NSColor.white.cgColor
        
    }
    
    func setHighlight(_ selected: Bool) {
        view.layer?.borderWidth = selected ? 5.0 : 0.0
    }
    
}
