//
//  ImageFile.swift
//  SlidesMagic
//
//  Created by ATM on 2017/11/6.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Foundation
import Cocoa

class ImageFile {
    private(set) var thumbnail: NSImage?
    private(set) var fileName: String
    
    init(url: URL) {
        fileName = url.lastPathComponent
        
        let imageSource = CGImageSourceCreateWithURL(url.absoluteURL as CFURL, nil)
        if let imageSource = imageSource {
            guard CGImageSourceGetType(imageSource) != nil else {return}
            thumbnail = getThumbnailImage(imageSource: imageSource)
        }
    }
    
    private func getThumbnailImage(imageSource: CGImageSource) -> NSImage? {
        let thumbnailOptions = [String(kCGImageSourceCreateThumbnailFromImageIfAbsent): true,
                                String(kCGImageSourceThumbnailMaxPixelSize): 160] as [String : Any]
        
        guard let thumbnailRef = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, thumbnailOptions as CFDictionary) else {
            return nil
        }
        return NSImage(cgImage: thumbnailRef, size: NSSize.zero)
    }
    
    
}






