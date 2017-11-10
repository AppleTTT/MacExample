//
//  ViewController.swift
//  Reader
//
//  Created by ATM on 2017/11/9.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController {

    @IBOutlet weak var outlineView: NSOutlineView!
    
    @IBOutlet weak var webView: WebView!
    
    var feeds: [Feed]?
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let filePath = Bundle.main.path(forResource: "Feeds", ofType: "plist") {
            feeds = Feed.feedList(filePath)
            print(feeds ?? "No Feeds")
        }
        dateFormatter.dateStyle = .short
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func doubleClickedItem(_ sender: NSOutlineView) {
        
        let item = sender.item(atRow: sender.clickedRow)
        if item is Feed {
            if sender.isItemExpanded(item) {
                sender.collapseItem(item)
            } else {
                sender.expandItem(item)
            }
        }
        
        
    }
    
    override func keyDown(with event: NSEvent) {
        interpretKeyEvents([event])
    }
    
    override func deleteBackward(_ sender: Any?) {
        let selectedRow = outlineView.selectedRow
        if selectedRow == -1 {
            return
        }
        outlineView.beginUpdates()
        if let item = outlineView.item(atRow: selectedRow){
            if let item = item as? Feed {
                if let index = self.feeds?.index(where: { $0.name == item.name }) {
                    self.feeds?.remove(at: index)
                    outlineView.removeItems(at: IndexSet(integer: index), inParent: nil, withAnimation: .slideLeft)
                }
            } else if let item = item as? FeedItem{
                for feed in self.feeds! {
                    if let index = feed.children.index(where: {$0.title == item.title}) {
                        feed.children.remove(at: index)
                        outlineView.removeItems(at: IndexSet(integer: index), inParent: feed, withAnimation: .slideLeft)
                    }
                }
            }
        }
        outlineView.endUpdates()
    }

}

extension ViewController: NSOutlineViewDataSource {

    /// 展示在 outlineView 中的每个层级都会逐步调用这个方法。
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let feed = item as? Feed {
            return feed.children.count
        }
        return feeds?.count ?? 0
    }
    // 每个 child index 返回的 item
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let feed = item as? Feed {
            return feed.children[index]
        }
        
        return feeds?[index] ?? (Any).self
    }
    
    /// 哪些 item 是可以折叠的,即是否左边有那个三角图标
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let feed = item as? Feed {
            return feed.children.count > 0
        }
        return false
    }
}

extension ViewController: NSOutlineViewDelegate {

    /// 一行一行的调用，每次调用一行的时候，都会把所有列的都调用一遍
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?
        if let feed = item as? Feed {
            if (tableColumn?.identifier)!.rawValue == "DateColumn" {
                if let textField = view?.textField {
                    textField.stringValue = ""
                    textField.sizeToFit()
                }
            } else {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FeedCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
                    textField.stringValue = feed.name
                    textField.sizeToFit()
                }
            }
        } else if let feedItem = item as? FeedItem {
            if (tableColumn?.identifier)!.rawValue == "DateColumn" {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DateCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
                    textField.stringValue = dateFormatter.string(from: feedItem.publishingDate)
                    textField.sizeToFit()
                }
            } else {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FeedItemCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
                    textField.stringValue = feedItem.title
                    textField.sizeToFit()
                }
            }
        }
        return view
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let outlineView = notification.object as? NSOutlineView else {
            return
        }
        
        let selecetdIndex = outlineView.selectedRow
        if let feedItem = outlineView.item(atRow: selecetdIndex) as? FeedItem{
            let url = URL(string: feedItem.url)
            if let url = url {
                webView.mainFrame.load(URLRequest(url: url))
            }
        }
        
        
    }


}





















