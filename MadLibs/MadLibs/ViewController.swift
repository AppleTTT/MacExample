//
//  ViewController.swift
//  MadLibs
//
//  Created by ATM on 2017/10/17.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var pasteTenseVerbTextField: NSTextField!
    
    @IBOutlet weak var singularNounCombo: NSComboBox!
    
    @IBOutlet var phraseTextView: NSTextView!
    
    
    fileprivate let singularNouns = ["dog", "muppet", "ninja", "pirate", "dev" ]
    
    
    @IBOutlet weak var pluralNounPopUpButton: NSPopUpButton!
    fileprivate let pluralNouns = ["tacos", "rainbows", "iPhones", "gold coins"]
    
    @IBOutlet weak var amountLabel: NSTextField!
    
    @IBOutlet weak var slider: NSSlider!
    
    @IBOutlet weak var datePicker: NSDatePicker!
    
    @IBOutlet weak var RWDevConRadioButton: NSButton!
    
    @IBOutlet weak var threeSixtyiDevRadioButton: NSButton!
    
    @IBOutlet weak var WWDCRadioButton: NSButton!
    
    @IBOutlet weak var yellChekcBox: NSButton!
    
    @IBOutlet weak var voiceSegmentedControl: NSSegmentedControl!
    
    @IBOutlet weak var resultTextField: NSTextField!
    
    @IBOutlet weak var imageView: NSImageView!
    
    
    fileprivate enum VoiceRate: Int {
        case slow
        case normal
        case fast
        
        var speed: Float {
            switch self {
            case .slow:
                return 60
            case .normal:
                return 175
            case .fast:
                return 360
            }
        }
    }
    fileprivate let synth = NSSpeechSynthesizer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        singularNounCombo.removeAllItems()
        singularNounCombo.addItems(withObjectValues: singularNouns)
        singularNounCombo.selectItem(at: singularNouns.count - 1)
        
        pluralNounPopUpButton.removeAllItems()
        pluralNounPopUpButton.addItems(withTitles: pluralNouns)
        pluralNounPopUpButton.selectItem(at: 0)

        pasteTenseVerbTextField.stringValue = "ate"
        
        phraseTextView.string = "Me coding Mac Apps!!!"
        
        slideChange(slider)
        
        datePicker.dateValue = Date()
        RWDevConRadioButton.state = NSControl.StateValue.on
        
        yellChekcBox.state = NSControl.StateValue.off
        
        voiceSegmentedControl.selectedSegment = 1;
        
    }

    @IBAction func goButtonClick(_ sender: NSButton) {
//        let pasteTenseValue = pasteTenseVerbTextField.stringValue
//        let singularValue = singularNounCombo.stringValue
//        let pluralNounPopUpValue = pluralNouns[pluralNounPopUpButton.indexOfSelectedItem]
//        let phraseValue = phraseTextView.string
//
//        let madLibSentence = "A \(singularValue) \(pasteTenseValue) \(pluralNounPopUpValue) \(phraseValue)"
//        print(madLibSentence)
//
//        readSentence(madLibSentence, rate: .normal)
        
        let pastTenseVerb = pasteTenseVerbTextField.stringValue
        let singlarNoun = singularNounCombo.stringValue
        let amount = slider.integerValue
        let pluralNoun = pluralNouns[pluralNounPopUpButton.indexOfSelectedItem]
        let phrase = phraseTextView.string
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let date = dateFormatter.string(from: datePicker.dateValue)
        
        var voice = "said"
        if yellChekcBox.state ==  NSControl.StateValue.on {
            voice = "yelled"
        }
        
        let sentence = "On \(date),at \(selectedPlace) a \(singlarNoun) \(pastTenseVerb) \(amount) \(pluralNoun) and \(voice), \(phrase)"
        
        resultTextField.stringValue = sentence
        imageView.image = NSImage(named: NSImage.Name(rawValue: "face"))
        
        let selectedSegment = voiceSegmentedControl.selectedSegment
        let voiceRate = VoiceRate(rawValue: selectedSegment) ?? .normal
        
        readSentence(sentence, rate: voiceRate)
        
        
        
        
        
        

    }
    
    fileprivate func readSentence(_ sentence: String, rate: VoiceRate) {
        synth.rate = rate.speed
        synth.stopSpeaking()
        synth.startSpeaking(sentence)
    }
    
    @IBAction func slideChange(_ sender: NSSlider) {
        let amount = sender.integerValue
        amountLabel.stringValue = "Amount:[\(amount)]"
        
    }
    
    
    @IBAction func radioButtonChanged(_ sender: NSButton) {
    }
    
    
    fileprivate var selectedPlace: String {
        var place = "home"
        if RWDevConRadioButton.state == NSControl.StateValue.on {
            place = "RWDevCon"
        }
        else if threeSixtyiDevRadioButton.state == NSControl.StateValue.on {
            place = "360iDev"
        }
        else if WWDCRadioButton.state == NSControl.StateValue.on {
            place = "WWDC"
        }
        return place
    }
    
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

