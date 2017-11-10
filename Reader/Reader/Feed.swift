//
//  Feed.swift
//  Reader
//
//  Created by ATM on 2017/11/9.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Cocoa

class Feed: NSObject {
    
    let name: String
    var children = [FeedItem]()
    
    
    init(name: String) {
        self.name = name
    }
    
    class func feedList(_ fileName: String) -> [Feed] {
        var feeds = [Feed]()
        if let feedList = NSArray(contentsOfFile: fileName) as? [NSDictionary] {
            for feedItem in feedList {
                let feed = Feed(name: feedItem.object(forKey: "name") as! String)
                let items = feedItem.object(forKey: "items") as! [NSDictionary]
                for dict in items {
                    let item = FeedItem(dictionary: dict)
                    feed.children.append(item)
                }
                feeds.append(feed)
            }
        }
        return feeds
    }
    
    
}
