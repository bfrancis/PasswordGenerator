//
//  PasswordGenerator.swift
//  Password Generator
//
//  Created by Brad Francis on 10/09/2015.
//  Copyright (c) 2015 The Friends' School. All rights reserved.
//

import Cocoa

class PasswordGenerator: NSObject {
    var pattern: String
    var lastPassword: Password?
    
    override init() {
        self.pattern = "CvccvcDD"
        self.lastPassword = nil
    }
    
    init(pattern: String) {
        self.pattern = pattern
        self.lastPassword = nil
    }
    
    func generate() -> String {
        var password = String()
        for x in pattern {
            switch(x) {
            case Character("C"):
                println("Uppercase consonant")
                break
            case Character("c"):
                println("Lowercase consonant")
                break
            case Character("V"):
                println("Uppercase vowel")
                break
            case Character("v"):
                println("Lowercase vowel")
                break
            case Character("D"):
                println("Digit")
                break
            case Character("d"):
                println("Digit")
                break
            default:
                println("Invalid.")
            }
        }
        
        return String()
    }
}
