//
//  QuotesViewController.swift
//  Quotes
//
//  Created by ATM on 2017/11/3.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Cocoa

class QuotesViewController: NSViewController {

    @IBOutlet weak var textLabel: NSTextField!
    
    let quotes = Quote.all
    var currentQuoteIndex: Int = 0 {
        didSet {
            updateQuote()
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        currentQuoteIndex = 0
    }
    
    func updateQuote() {
        textLabel.stringValue = String(describing: quotes[currentQuoteIndex])
    }
    
    
    @IBAction func previous(_ sender: NSButton) {
        currentQuoteIndex = (currentQuoteIndex - 1 + quotes.count) % quotes.count
    }
    
    @IBAction func next(_ sender: NSButton) {
        currentQuoteIndex = (currentQuoteIndex + 1) % quotes.count
    }
    
    @IBAction func quit(_ sender: NSButton) {
        NSApplication.shared.terminate(sender)
    }
    
    
    
}



extension QuotesViewController {
    
    static func freshController() -> QuotesViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "QuotesViewController")
        
        guard let viewController = storyboard.instantiateController(withIdentifier: identifier) as? QuotesViewController else {
            fatalError("Why cant I find QuotesViewController? - Check Main.storyboard")
        }
        return viewController
    }
    
    
    
    
}






