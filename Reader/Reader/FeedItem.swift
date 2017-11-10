//
//  FeedItem.swift
//  Reader
//
//  Created by ATM on 2017/11/9.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Cocoa

class FeedItem: NSObject {

    let url: String
    let title: String
    let publishingDate: Date
    
    init(dictionary: NSDictionary) {
        self.url = dictionary.object(forKey: "url") as! String
        self.title = dictionary.object(forKey: "title") as! String
        self.publishingDate = dictionary.object(forKey: "date") as! Date
    }
}
