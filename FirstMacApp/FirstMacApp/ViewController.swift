//
//  ViewController.swift
//  FirstMacApp
//
//  Created by ATM on 2017/10/17.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var nameTextField: NSTextField!
    
    @IBOutlet weak var welcomeLabel: NSTextFieldCell!
    
    @IBOutlet weak var ballImageView: NSImageView!
    
    @IBOutlet weak var adviceLabel: NSTextField!
    
    let adviceList = [
        "Yes",
        "No",
        "Ray says 'do it!'",
        "Maybe",
        "Try again later",
        "How can I know?",
        "Totally",
        "Never",
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func handleWelcome(_ sender: NSButton) {
        
        welcomeLabel.stringValue = "Hello \(nameTextField.stringValue)!"
        
        
    }
    
    @IBAction func handleBallClick(_ sender: NSClickGestureRecognizer) {
        if adviceLabel.isHidden {
            if let advice = adviceList.randomElement {
                adviceLabel.stringValue = advice
                adviceLabel.isHidden = false
                ballImageView.image = NSImage(named: NSImage.Name(rawValue: "magic8ball"))
            }
        }else {
            adviceLabel.isHidden = true
            ballImageView.image = NSImage(named: NSImage.Name(rawValue: "8ball"))
        }
        
        
        
        
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


extension Array {
    var randomElement: Element? {
        if count < 1 { return .none }
        let randomIndex = arc4random_uniform(UInt32(count))
        return self[Int(randomIndex)]
 
    }
}

