//
//  PrefsViewController.swift
//  EggTimer
//
//  Created by ATM on 2017/10/31.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Cocoa

class PrefsViewController: NSViewController {

    @IBOutlet weak var presetsPopup: NSPopUpButton!
    
    @IBOutlet weak var customSlider: NSSlider!
    
    @IBOutlet weak var customTextField: NSTextField!
    
    var prefs = Preferences()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        showExistingPrefs()
    }
    
    @IBAction func popupValueChanged(_ sender: NSPopUpButton) {
        if sender.selectedItem?.title == "Custom" {
            customSlider.isEnabled = true
            return
        }
        let newTimeDuration = sender.selectedTag()
        customSlider.integerValue = newTimeDuration
        showSliderValueAsText()
        customSlider.isEnabled = false
    }
    
    @IBAction func sliderValueChanged(_ sender: NSSlider) {
        showSliderValueAsText()
    }
    
    @IBAction func cancelButtonClicked(_ sender: NSButton) {
        view.window?.close()
    }
    
    @IBAction func okButtonCicked(_ sender: NSButton) {
        saveNewPrefs()
        view.window?.close()
    }
    
    
    
    func showExistingPrefs() {
        let selectedTimeInMinutes = Int(prefs.selectedTime) / 60
        presetsPopup.selectItem(withTitle: "Custom")
        customSlider.isEnabled = true
        
        for item in presetsPopup.itemArray {
            if item.tag == selectedTimeInMinutes {
                presetsPopup.select(item)
                customSlider.isEnabled = false
                break
            }
        }
        
        customSlider.integerValue = selectedTimeInMinutes
        showSliderValueAsText()
        
    }
    
    
    func showSliderValueAsText() {
        let newTimerDuration = customSlider.integerValue
        let minutesDescription = (newTimerDuration == 1) ? "minute" : "minutes"
        customTextField.stringValue = "\(newTimerDuration) \(minutesDescription)"
    }
    
    func saveNewPrefs() {
        prefs.selectedTime = customSlider.doubleValue * 60
        NotificationCenter.default.post(name: Notification.Name(rawValue: "PrefsChanged"), object: nil)
    }
    
    
    
    
    
    
    
    
    
}
