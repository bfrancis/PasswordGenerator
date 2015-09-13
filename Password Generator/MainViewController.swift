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
    @IBOutlet weak var selectAllButton: NSButton!
    @IBOutlet weak var unselectAllButton: NSButton!
    
    
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
        var range = NSRange()
        range.location = 0
        range.length = self.passwords.count
        
        debug("Number of rows in table: \(range.length)")
        
        self.passwordsTableView.removeRowsAtIndexes(NSIndexSet(indexesInRange: range), withAnimation: nil)
        
        // Empty passwords array
        passwords = [Password]()
        
        // (Re)Populate passwords array
        for x in (1...numPasswordsCounter) {
            var pass = generator.generate()
            passwords.append(pass)
        }
        
        range.length = passwords.endIndex
        
        self.passwordsTableView.insertRowsAtIndexes(NSIndexSet(indexesInRange: range), withAnimation: NSTableViewAnimationOptions.EffectGap)
    }
    
    @IBAction func selectAllButtonPressed(sender: NSButton) {
        var checkboxColumnIndex = passwordsTableView.columnWithIdentifier("SelectBoxColumn")
        var rowsCount = self.numberOfRowsInTableView(passwordsTableView)
        
        debug("Number of rows: \(rowsCount)")
        
        for row in (0..<rowsCount) {
            var view = passwordsTableView.viewAtColumn(checkboxColumnIndex, row: row, makeIfNecessary: false) as! NSView
            
            var subviews = view.subviews
            
            for i in (0..<subviews.count) {
                var currentSubView: AnyObject = subviews[i]
                
                if let checkbox = currentSubView as? NSButton {
                    checkbox.
                }
            }
        }
    }
}

extension MainViewController: NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        
        debug("Passwords count: \(self.passwords.count)")
        return self.passwords.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        
        // Create a password cell view
        if tableColumn!.identifier == "PasswordColumn" {
            let password = self.passwords[row]
            cellView.textField!.stringValue = password.value
            return cellView
        }
        
        // Create a select box cell view
//        if tableColumn!.identifier == "SelectBoxColumn" {
//            var selectBox = NSCheck
//        }
        
        return cellView
    }
}

