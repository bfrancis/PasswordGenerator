//
//  PasswordGenerator.swift
//  Password Generator
//
//  Created by Brad Francis on 10/09/2015.
//  Copyright (c) 2015 The Friends' School. All rights reserved.
//

import Cocoa

class PasswordGenerator {
    var pattern: String
    var lastPassword: Password?
    var intToChar: (Int) -> Character
    var letters: [Character]
    var vowels: [Character]
    var consonants: [Character]
    var digits: [Int]
    
    init() {
        self.pattern = "CvccvcDD"
        self.intToChar = { x in return Character(UnicodeScalar(x)) }
        self.lastPassword = nil
        self.letters = (65...90).map(intToChar)
        self.vowels = Array("AEIOU")
        self.consonants = letters.filter({ !contains(Array("AEIOU"), $0) })
        self.digits = (0..<10).map({(x: Int) -> Int in return x})
    }
    
    convenience init(pattern: String) {
        self.init()
        self.pattern = pattern
    }
    
    func randomFromArray(arr: Array<Character>) -> Character {
        let count = UInt32(arr.count)
        let index = Int(arc4random_uniform(count))
        
        return arr[index]
    }
    
    func randomFromArray(arr: Array<Int>) -> Int {
        let count = UInt32(arr.count)
        let index = Int(arc4random_uniform(count))
        
        return arr[index]
    }
    
    func generate() -> Password {
        var password = String()
        var count = 1
        for x in self.pattern {
            switch(x) {
            case Character("C"):
                password += String(randomFromArray(consonants)).uppercaseString
                break
            case Character("c"):
                password += String(randomFromArray(consonants)).lowercaseString
                break
            case Character("V"):
                password += String(randomFromArray(vowels)).uppercaseString
                break
            case Character("v"):
                password += String(randomFromArray(vowels)).lowercaseString
                break
            case Character("D"):
                password += String(randomFromArray(digits))
                break
            case Character("d"):
                password += String(randomFromArray(digits))
                break
            default:
                println("Invalid.")
            }
        }
        
        return Password(value: password, pattern: self.pattern)
    }
}
