//
//  Panagram.swift
//  Panagram
//
//  Created by ATM on 2017/11/2.
//  Copyright © 2017年 QYCloud. All rights reserved.
//

import Foundation

enum OptionType: String {
    case palindrome = "p"
    case anagram = "a"
    case help = "h"
    case unknown
    case quit = "q"
    
    init(value: String) {
        switch value {
        case "p": self = .palindrome
        case "a": self = .anagram
        case "h": self = .help
        case "q": self = .quit
        default: self = .unknown
        }
    }
}




class Panagram {
    let consoleIO = ConsoleIO()
    
    func staticMode() {
        let argCount = CommandLine.argc
        let argument = CommandLine.arguments[1]
        let argumentSubstring = argument[argument.index(after: argument.startIndex)...]
        
        let (option, value) = getOption(String(argumentSubstring))

        switch option {
        case .anagram:
            if argCount != 4 {
                if argCount > 4 {
                    consoleIO.writeMessage("Too many arguments for option \(option.rawValue)", to: .error)
                }else {
                    consoleIO.writeMessage("Too few arguments for option \(option.rawValue)", to: .error)
                }
                consoleIO.printUsage()
            } else {
                let first = CommandLine.arguments[2]
                let second = CommandLine.arguments[3]
                
                if first.isAnagramOf(second) {
                    consoleIO.writeMessage("\(second) is an anagram of \(first)")
                }else {
                    consoleIO.writeMessage("\(second) is not an anagram of \(first)")
                }
            }
        case .palindrome:
            if argCount != 3 {
                if argCount > 3 {
                    consoleIO.writeMessage("Too many arguments for option \(option.rawValue)", to: .error)
                } else {
                    consoleIO.writeMessage("Too few arguments for option \(option.rawValue)", to: .error)
                }
                consoleIO.printUsage()
            } else {
                //5
                let s = CommandLine.arguments[2]
                let isPalindrome = s.isPalingdrome()
                consoleIO.writeMessage("\(s) is \(isPalindrome ? "" : "not ")a palindrome")
            }
        //6
        case .help:
            consoleIO.printUsage()
        case .unknown:
            //7
            consoleIO.writeMessage("Unknown option \(value)")
            consoleIO.printUsage()
        case .quit: break
            
        }
    }
    
    func interactiveMode(){
        consoleIO.writeMessage("Welcome to Panagram. This program checks if an input string is an anagram or palindrome.")
        var shouldQiut = false
        while !shouldQiut {
            consoleIO.writeMessage("Type 'a' to check for anagrams or 'p' for palindromes type 'q' to quit.")
            let (option, value) = getOption(consoleIO.getInput())
            switch option {
            case .anagram:
                consoleIO.writeMessage("Type the first string:")
                let first = consoleIO.getInput()
                consoleIO.writeMessage("Type the second string:")
                let second = consoleIO.getInput()
                if first.isAnagramOf(second) {
                    consoleIO.writeMessage("\(second) is an anagram of \(first)")
                } else {
                    consoleIO.writeMessage("\(second) is not an anagram of \(first)")
                }
            case .palindrome:
                consoleIO.writeMessage("Type a word or sentence:")
                let s = consoleIO.getInput()
                let isPalindrome = s.isPalingdrome()
                consoleIO.writeMessage("\(s) is \(isPalindrome ? "" : "not ")a palindrome")
            case .quit: shouldQiut = true
            default:
                consoleIO.writeMessage("Unknown option \(value)", to: .error)
            }
            
        }
        
    }
    
    
    func getOption(_ option: String) -> (option: OptionType, value: String) {
        return (OptionType(value: option), option)
    }
    
    
}






