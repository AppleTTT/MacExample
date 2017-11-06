//
//  ViewController.swift
//  EggTimer
//
//  Created by ATM on 2017/10/30.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {

    @IBOutlet weak var timeLeftLabel: NSTextField!
    
    @IBOutlet weak var eggImageView: NSImageView!
    
    @IBOutlet weak var startButton: NSButton!
    
    @IBOutlet weak var stopButton: NSButton!
    
    @IBOutlet weak var resetButton: NSButton!
    
    var eggTimer = EggTimer()
    var prefs = Preferences()
    var soundPlayer: AVAudioPlayer?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eggTimer.delegate = self
        setupPrefs()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: - IBActions - buttons
    @IBAction func startButtonClicked(_ sender: Any) {
        
        if eggTimer.isPaused {
            eggTimer.resumeTimer()
        }else {
            eggTimer.duration = prefs.selectedTime
            eggTimer.startTimer()
        }
        configureButtonsAndMenus()
        prepareSound()
    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        eggTimer.stopTimer()
        configureButtonsAndMenus()
    }
    
    @IBAction func resetButtonClicked(_ sender: Any) {
        eggTimer.resetTimer()
        updateDisplay(for: 360)
        prefs.selectedTime = 360
        configureButtonsAndMenus()
    }
    
    
    // MARK: - IBActions - menus
    @IBAction func startTimerMenuItemSelected(_ sender: Any) {
        startButtonClicked(sender)
    }
    @IBAction func stopTimerMenuItemSelected(_ sender: Any) {
        stopButtonClicked(sender)
    }
    @IBAction func resetTimerMenuItemSelected(_ sender: Any) {
        resetButtonClicked(sender)
    }
}

extension ViewController: EggTimerProtocol {
    func timeHasFinished(_ timer: EggTimer) {
        updateDisplay(for: 0)
        playSound()
        configureButtonsAndMenus()
    }
    
    func timeRemainOnTimer(_ timer: EggTimer, timeRemaining: TimeInterval) {
        updateDisplay(for: timeRemaining)
    }
}

extension ViewController {
    // MARK: - update UI
    func updateDisplay(for timeRemaining: TimeInterval) {
        timeLeftLabel.stringValue = textToDisplay(for: timeRemaining)
        eggImageView.image = imageToDisplay(for: timeRemaining)
    }
    
    private func textToDisplay(for timeRemaining: TimeInterval) -> String {
        if timeRemaining == 0 {
            return "Done!"
        }
        let minutesRemaining = floor(timeRemaining / 60)
        let secondRemaining = timeRemaining - minutesRemaining * 60
        let secondDisplay = String(format: "%02d", Int(secondRemaining))
        let timeRemainingDisplay = "\(Int(minutesRemaining)):\(secondDisplay)"
        
        return timeRemainingDisplay
        
    }
    
    private func imageToDisplay(for timeRemaining: TimeInterval) -> NSImage? {
        let percentageComplete = 100 - (timeRemaining / 360 * 100)
        if eggTimer.isStopped {
            let stoppedImageName = (timeRemaining == 0) ? "100" : "stopped"
            return NSImage(named: NSImage.Name(rawValue: stoppedImageName))
        }
        let imageName: String
        switch percentageComplete {
        case 0 ..< 25: imageName = "0"
        case 25 ..< 50: imageName = "25"
        case 50 ..< 75: imageName = "50"
        case 75 ..< 100: imageName = "75"
        default: imageName = "100"
            
        }
        return NSImage(named: NSImage.Name(rawValue: imageName))
    }
    
    func configureButtonsAndMenus() {
        let enableStart: Bool
        let enableStop: Bool
        let enableReset: Bool
        if eggTimer.isStopped {
            enableStart = true
            enableStop = false
            enableReset = false
        }else if eggTimer.isPaused {
            enableStart = true
            enableStop = false
            enableReset = true
        }else {
            enableStart = false
            enableStop = true
            enableReset = false
        }
        
        startButton.isEnabled = enableStart
        stopButton.isEnabled = enableStop
        resetButton.isEnabled = enableReset
        
        if let appDel = NSApplication.shared.delegate as? AppDelegate {
            appDel.enableMenus(start: enableStart, stop: enableStop,
                               reset: enableReset)
        }
        
    }
}

extension ViewController {
    // MARK: - Preferences
    func setupPrefs() {
        updateDisplay(for: prefs.selectedTime)
        let notificationName = Notification.Name(rawValue: "PrefsChanged")
        NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) { (notification) in
             self.checkForResetAfterPrefsChange()
        }
    }
    
    func updateFromPrefs() {
        eggTimer.resetTimer()
        eggTimer.duration = self.prefs.selectedTime
        updateDisplay(for: self.eggTimer.duration)
        configureButtonsAndMenus()
    }
}

extension ViewController {
    // MARK: - Alert
    func checkForResetAfterPrefsChange() {
        if eggTimer.isPaused || eggTimer.isStopped {
            updateFromPrefs()
        }else {
            let alter = NSAlert()
            alter.messageText = "Reset timer with the new settings?"
            alter.informativeText = "This will stop your current timer!"
            alter.alertStyle = .warning
            alter.addButton(withTitle: "Reset")
            alter.addButton(withTitle: "Cancel")
            let response = alter.runModal()
            if response == NSApplication.ModalResponse.alertFirstButtonReturn {
                self.updateFromPrefs()
            }
        }
    }
}

extension ViewController {
    // MARK: - Sound
    func prepareSound() {
        guard let audioFileUrl = Bundle.main.url(forResource: "ding", withExtension: "mp3") else {
            return
        }
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
            soundPlayer?.prepareToPlay()
        } catch  {
            print("Sound player not available: \(error)")
        }
    }
    
    func playSound() {
        soundPlayer?.play()
    }
}








