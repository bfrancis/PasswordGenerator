//
//  MainViewController.swift
//  Password Generator
//
//  Created by Brad Francis on 9/09/2015.
//  Copyright (c) 2015 The Friends' School. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    let DEBUG = true
    
    var numPasswordsCounter = 1
    var numPasswordsFormatter = IntegerOnlyFormatter()
    var passwords = [Password]()
    let generator = PasswordGenerator()
    
    @IBOutlet weak var numPasswordsTextField: NSTextField!
    @IBOutlet weak var numPasswordsStepper: NSStepper!
    @IBOutlet weak var passwordsTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Formatter
        numPasswordsFormatter.minimum = 1
        numPasswordsFormatter.maximum = 9999
        
        // Bind formatter to text field
        numPasswordsTextField.formatter = numPasswordsFormatter
        
        numPasswordsStepper.maxValue = Double(numPasswordsFormatter.maximum)
        numPasswordsStepper.minValue = Double(numPasswordsFormatter.minimum)
        
        // "Bind" `numPasswordsCounter` to both the text field
        // and the stepper
        updateCounterControls()
    }
    
    func debug(message: String) {
        if DEBUG {
            println(message)
        }
    }
    
    func updateCounterControls() {
        numPasswordsStepper.integerValue = numPasswordsCounter
        numPasswordsTextField.integerValue = numPasswordsCounter
    }
}

extension MainViewController {
    @IBAction func stepperValueChanged(sender: NSStepper) {
        numPasswordsCounter = sender.integerValue
        updateCounterControls()
        
        debug("Counter: " + String(numPasswordsCounter))
        debug("Stepper: " + String(numPasswordsStepper.integerValue))
    }
    
    
    @IBAction func textEntered(sender: NSTextField) {
        numPasswordsCounter = sender.integerValue
        updateCounterControls()
        
        debug("Text Entered: " + sender.stringValue)
        debug("Formatter Minimum: " + numPasswordsFormatter.minimum.stringValue)
    }
    
    @IBAction func generateButtonClicked(sender: NSButton) {
        // Empty passwords array
        passwords = [Password]()
        
        // Populate passwords array
        for x in (1...numPasswordsCounter) {
            var pass = generator.generate()
            
//            println("Password: " + pass.value)
            
            passwords.append(pass)
        }
        
        var range = NSRange()
        range.location = passwords.startIndex
        range.length = passwords.endIndex
        
    self.passwordsTableView.insertRowsAtIndexes(NSIndexSet(indexesInRange: range), withAnimation: NSTableViewAnimationOptions.EffectGap)
    }
}

extension MainViewController: NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return self.passwords.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        
        debug("tableView(): Making cell")
        
        if tableColumn!.identifier == "PasswordColumn" {
            debug("Making PasswordColumn cell")
            let password = self.passwords[row]
            cellView.textField!.stringValue = password.value
            return cellView
        }
        
        return cellView
    }
}

