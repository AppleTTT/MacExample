//
//  StringExtension.swift
//  Panagram
//
//  Created by ATM on 2017/11/3.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Foundation


extension String {
    
    func isAnagramOf(_ s: String) -> Bool {
        let lowerSelf = self.lowercased().replacingOccurrences(of: " ", with: "")
        let lowerOther = s.lowercased().replacingOccurrences(of: " ", with: "")
        
        return lowerSelf.sorted() == lowerOther.sorted()
    }
    
    func isPalingdrome() ->Bool {
        let f = self.lowercased().replacingOccurrences(of: " ", with: "")
        let s = String(f.reversed())
        return f == s
    }
    
}


