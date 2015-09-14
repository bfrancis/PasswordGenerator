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
    var pasteboard = NSPasteboard.generalPasteboard()
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
    
    func getAllCheckboxes() -> [NSButton] {
        var checkboxes = [NSButton]()
        
        // The index of the column containing the checkboxes
        var checkboxColumnIndex = passwordsTableView.columnWithIdentifier("SelectBoxColumn")
        
        // The number of rows in the Table View
        var rowsCount = self.numberOfRowsInTableView(passwordsTableView)
        
        // Iterate through each row of the Table View
        for row in (0..<rowsCount) {
            // The view containing the check box
            var view = passwordsTableView.viewAtColumn(checkboxColumnIndex, row: row, makeIfNecessary: false) as! NSView
            
            // An array of subviews within the checkbox column
            var subviews = view.subviews
            
            // Iterate through all the subviews and try to find
            // an NSButton object (the checkbox)
            for i in (0..<subviews.count) {
                var currentSubView: AnyObject = subviews[i]
                
                // Attempt to downcast the current subview (AnyObject) to an NSButton
                if let checkbox = currentSubView as? NSButton {
                    checkboxes.append(checkbox)
                }
            }
        }
        
        return checkboxes
    }
    
    func getPasswordAtRow(row: Int) -> String {
        var passwordColumnIndex = passwordsTableView.columnWithIdentifier("PasswordColumn")
        
        // The view containing the password
        var view = passwordsTableView.viewAtColumn(passwordColumnIndex, row: row, makeIfNecessary: false) as! NSView
        
        if let cellView = view as? NSTableCellView {
            if let textField = cellView.textField {
                return textField.stringValue
            }
        }
        
        return String()
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
        
        // Pretend 'Unselect All' button was pressed. 
        // (A lazy way to unselect all the checkboxes before they get recreated)
        self.unselectAllButtonPressed(sender)
        
        // Remove all the passwords
        self.passwordsTableView.removeRowsAtIndexes(NSIndexSet(indexesInRange: range), withAnimation: nil)
        
        // Empty passwords array
        passwords = [Password]()
        
        // (Re)Populate passwords array
        for x in (1...numPasswordsCounter) {
            var pass = generator.generate()
            passwords.append(pass)
        }
        
        // Update the length on the range (NSRange)
        range.length = passwords.endIndex
        
        self.passwordsTableView.insertRowsAtIndexes(NSIndexSet(indexesInRange: range), withAnimation: NSTableViewAnimationOptions.EffectGap)
    }
    
    @IBAction func selectAllButtonPressed(sender: NSButton) {
        
        // Get all the checkboxes in the Table View
        var checkboxes = getAllCheckboxes()
        
        // Iterate through and set them all to "On" (selected)
        for box in checkboxes {
            box.state = NSOnState
        }
    }
    
    @IBAction func unselectAllButtonPressed(sender: NSButton) {
        
        // Get all the checkboxes in the Table View
        var checkboxes = getAllCheckboxes()
        
        // Iterate through and set them all to "Off" (unselected)
        for box in checkboxes {
            box.state = NSOffState
        }
    }
    
    @IBAction func copySelectedButtonPressed(sender: NSButton) {
        var checkboxes = getAllCheckboxes()
        var copyToClipboard = String()
        var password = String()
        
        // Clear the contents of the clipboard
        pasteboard.clearContents()
        
        for i in (0..<checkboxes.count) {
            if (checkboxes[i].state == NSOnState) {
               password = getPasswordAtRow(i)
                
                // Add the password to the string that gets copied
                // to the clipboard
                copyToClipboard += password
                copyToClipboard += "\n"
            }
        }
        
        if (count(copyToClipboard) > 0) {
            debug("Copying \(self.passwords.count) passwords to clipboard")
            pasteboard.writeObjects([copyToClipboard])
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
        
        return cellView
    }
}

