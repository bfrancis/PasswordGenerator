//
//  IntegerOnlyFormatter.swift
//  Password Generator
//
//  Created by Brad Francis on 9/09/2015.
//  Copyright (c) 2015 The Friends' School. All rights reserved.
//

import Cocoa

class IntegerOnlyFormatter: NSNumberFormatter {
    override func isPartialStringValid(partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
        if (count(partialString) == 0) {
            return true
        }

        let scanner = NSScanner(string: partialString)

        if (scanner.scanInt(nil) && scanner.atEnd) {
            return true
        }

        NSBeep()
        return false
    }
}
