//
//  main.swift
//  Panagram
//
//  Created by ATM on 2017/11/2.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Foundation

let panagram = Panagram()


if CommandLine.argc < 2 {
    panagram.interactiveMode()
}else {
    panagram.staticMode()
}


