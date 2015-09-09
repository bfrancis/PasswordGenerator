//
//  MainViewController.swift
//  Password Generator
//
//  Created by Brad Francis on 9/09/2015.
//  Copyright (c) 2015 The Friends' School. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    @IBOutlet weak var numPasswords: NSTextField!
    
    var numPasswordsFormatter = IntegerOnlyFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numPasswordsFormatter.minimum = 1
        numPasswordsFormatter.maximum = 9999
        numPasswords.formatter = numPasswordsFormatter
        numPasswords.integerValue = 1
    }
    
}
