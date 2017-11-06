//
//  EggTimer.swift
//  EggTimer
//
//  Created by ATM on 2017/10/31.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Foundation


class EggTimer {
    var timer: Timer? = nil
    var startTime: Date?
    var duration: TimeInterval = 360  // default is 6 minutes
    var elapsedTime: TimeInterval = 0
    
    
    var isStopped: Bool {
        return timer == nil && elapsedTime == 0
    }
    
    var isPaused: Bool {
      return timer == nil && elapsedTime > 0
    }
    
    var delegate: EggTimerProtocol?
    
    
    @objc dynamic func timeAction() {
        guard let startTime = startTime else {
            return
        }
        elapsedTime = -startTime.timeIntervalSinceNow
        let secondRemaining = (duration - elapsedTime).rounded()
        if secondRemaining <= 0 {
            resetTimer()
            delegate?.timeHasFinished(self)
        }else {
            delegate?.timeRemainOnTimer(self, timeRemaining: secondRemaining)
        }
        
    }
    
    func startTimer() {
        startTime = Date()
        elapsedTime = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeAction), userInfo: nil, repeats: true)
        timeAction()
    }
    
    func resumeTimer() {
        startTime = Date(timeIntervalSinceNow:  -elapsedTime)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeAction), userInfo: nil, repeats: true)
        timeAction()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timeAction()
    }
    
    func resetTimer() {
        timer = nil
        startTime = nil
        duration = 360
        elapsedTime = 0
        timeAction()
    }
    
}


protocol EggTimerProtocol {
    func timeRemainOnTimer(_ timer: EggTimer, timeRemaining: TimeInterval)
    
    func timeHasFinished(_ timer: EggTimer)
}
