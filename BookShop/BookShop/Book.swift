//
//  Book.swift
//  BookShop
//
//  Created by ATM on 2017/11/9.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Foundation


struct Book {
    let title: String
    let cover: String
    let edition: String
    let url: URL
    
    var thumb: String {
        return cover + "_t"
    }
    
    static func all() -> [Book]{
        
        return (NSArray(contentsOfFile: Bundle.main.path(forResource: "Books", ofType: "plist")!)?.map({ row -> Book in
            let book = row as! NSDictionary
            return Book(title: book["title"] as! String, cover: book["cover"] as! String, edition: book["edition"] as! String, url: URL(string: book["url"] as! String)!)
        }))!
        
        
//        return NSArray(contentsOfFile: Bundle.main.path(forResource: "Books", ofType: "plist")!)?.map({ row -> Book in
//            let book = row as! NSDictionary
//            return Book(title: book["title"] as! String, cover: book["cover"] as! String, edition: book["edition"] as! String, url: URL(string: book["url"] as! String)!)
//        })
       
    }
    
    
    
}
















