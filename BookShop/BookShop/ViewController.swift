//
//  ViewController.swift
//  BookShop
//
//  Created by ATM on 2017/11/9.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var coverImageView: NSImageView!
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var editionTextField: NSTextField!
    
    @IBOutlet weak var topStack: NSStackView!
    
    
    
    
    let books = Book.all()
    
    
    @IBAction func actionToggleListView(_ sender: AnyObject) {
        if let button = sender as? NSToolbarItem {
            switch button.tag {
            case 0:
                button.tag = 1
                button.image = NSImage(named: NSImage.Name("list-selected-icon"))
            case 1:
                button.tag = 0
                button.image = NSImage(named: NSImage.Name("list-icon"))
            default: break
            }
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.25
                context.allowsImplicitAnimation = true
                topStack.arrangedSubviews.first?.isHidden = button.tag == 0
                view.layoutSubtreeIfNeeded()
            }, completionHandler: nil)
        }
        
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


extension ViewController {
    override func viewWillAppear() {
        super.viewWillAppear()
        if let window = view.window {
//            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.isMovableByWindowBackground = true
        }
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(calibratedWhite: 0.95, alpha: 1).cgColor
        
        tableView.selectRowIndexes(IndexSet.init(integer: 0), byExtendingSelection: false)
        displayBookDetails(book: books[tableView.selectedRow >= 0 ? tableView.selectedRow : 0])
    }
    
    func displayBookDetails(book: Book) {
        coverImageView.image = NSImage(named: NSImage.Name(rawValue: book.cover))
        titleTextField.stringValue = book.title
        editionTextField.stringValue = book.edition
    }
    
    @IBAction func actionBuySelectedBook(sender: AnyObject) {
        let book = books[tableView.selectedRow >= 0 ? tableView.selectedRow : 0]
        NSWorkspace.shared.open(book.url)
    }
    
}

extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return (books.count)
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "BookCell"), owner: nil) as! BookCellView
        let book = books[row]
        
        cell.coverImage.image = NSImage(named: NSImage.Name(book.thumb))
        cell.bookTitle.stringValue = book.title
        
        return cell
    }
    
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        displayBookDetails(book: books[row])
        return true
    }
}































