//
//  ConsoleIO.swift
//  Panagram
//
//  Created by ATM on 2017/11/2.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Foundation

enum OutputType {
    case error
    case standard
}




class ConsoleIO {
    
    func writeMessage(_ message: String, to: OutputType = .standard) {
        switch to {
        case .standard:
            print("\u{001B}[;m \(message)")
        case .error:
            fputs("\u{001B}[0;31m \(message)\n", stderr)// 将 message 写入到 stderr 中，它是一个指向到标准错误流的全局变量
        }
    }
    
    func printUsage() {
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        writeMessage("usage:")
        writeMessage("\(executableName) -a string1 string2")
        writeMessage("or")
        writeMessage("\(executableName) -p string")
        writeMessage("or")
        writeMessage("\(executableName) -h to show usage information")
        writeMessage("Type \(executableName) without an option to enter interactive mode.")
        
    }
    
    func getInput() -> String {
        let keyboard = FileHandle.standardInput
        let inputData = keyboard.availableData
        let strData = String(data: inputData, encoding: .utf8)!
        
        return strData.trimmingCharacters(in: CharacterSet.newlines)
    }
    
    
    
    
}


