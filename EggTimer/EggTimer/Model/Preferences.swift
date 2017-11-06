//
//  Preferences.swift
//  EggTimer
//
//  Created by ATM on 2017/11/1.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Foundation

struct Preferences {
    var selectedTime: TimeInterval {
        get{
            let savedTime = UserDefaults.standard.double(forKey: "selectedTime")
            if savedTime > 0 {
                return savedTime
            }
            return 360
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedTime")
//            UserDefaults.standard.synchronize()
        }
    }
}






