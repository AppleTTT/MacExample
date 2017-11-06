//
//  EventMonitor.swift
//  Quotes
//
//  Created by ATM on 2017/11/3.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Foundation
import Cocoa


public class EventMonitor {
    
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent?) -> Void

    public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void) {
        self.mask = mask
        self.handler = handler
    }
    
    deinit {
        
    }
    
    public func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }
    
    public func stop() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor  = nil
        }
    }
    
    
}




