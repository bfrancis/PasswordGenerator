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
    var objects = [Int : Dictionary<String, AnyObject>]()
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
        numPasswordsFormatter.maximum = 999
        
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
    
    func reset() {
        
        // Resets the passwords array
        if self.passwords.count > 0 {
            self.passwords = [Password]()
        }
        
        // Resets the dictionary that stores a reference to each checkbox/password pair
        if self.objects.count > 0 {
            self.objects = [Int : Dictionary<String, AnyObject>]()
        }
        
        // Set all checkboxes to "Off"
        toggleAllCheckboxes(NSOffState)
    }
    
    func getAllCheckboxes() -> [NSButton] {
        var checkboxes: [NSButton] = Array()
        
        for i in (0..<self.objects.count) {
            if let object = self.objects[i] {
                if let checkbox = object["checkbox"] as? NSButton {
                    checkboxes.append(checkbox)
                }
            }
        }
        
        return checkboxes
    }
    
    //
    func addToObjectsArray(index: Int, key: String, value: AnyObject) {
        if objects[index] != nil {
            objects[index]?.updateValue(value, forKey: key)
        } else {
            objects[index] = [key : value]
        }
    }
    
    // Toggle all checkboxes
    func toggleAllCheckboxes(state: Int) {
        
        // Ensure state is valid
        if (state == NSOnState || state == NSOffState) {
            var checkboxes = getAllCheckboxes()
            
            for box in checkboxes {
                box.state = state
            }
        }
    }
    
    
    // Retreive the password at a specified row
    func getPasswordAtRow(row: Int) -> String {
        if let object = self.objects[row] {
            if let password = object["password"] as? String {
                return password
            }
        }
        
        return String()
    }

    func updateCounterControls() {
        numPasswordsStepper.integerValue = numPasswordsCounter
        numPasswordsTextField.integerValue = numPasswordsCounter
    }
    
    func reloadData() {
        debug("Number of rows in table before reload: \(passwordsTableView.numberOfRows)")
        
        passwordsTableView.reloadData()
        debug("Number of rows in table after reload: \(passwordsTableView.numberOfRows)")
        
        passwordsTableView.ro
        
        var rowIndexes = NSRange()
        rowIndexes.location = 0
        rowIndexes.length = passwordsTableView.numberOfRows
        
        var columnIndexes = NSRange()
        columnIndexes.location = 0
        columnIndexes.length = passwordsTableView.numberOfColumns
        
        passwordsTableView.reloadDataForRowIndexes(NSIndexSet(indexesInRange: rowIndexes), columnIndexes: NSIndexSet(indexesInRange: columnIndexes))
    }
    
}

extension MainViewController {
    @IBAction func stepperValueChanged(sender: NSStepper) {
        numPasswordsCounter = sender.integerValue
        updateCounterControls()
    }
    
    @IBAction func textEntered(sender: NSTextField) {
        numPasswordsCounter = sender.integerValue
        updateCounterControls()
        
        debug("Text Entered: " + sender.stringValue)
        debug("Formatter Minimum: " + numPasswordsFormatter.minimum.stringValue)
    }
    
    @IBAction func generateButtonClicked(sender: NSButton) {
        
        // Reset passwords array and objects dictionary
        reset()
        
        // (Re)Populate passwords array
        for x in (1...numPasswordsCounter) {
            var pass = generator.generate()
            passwords.append(pass)
        }
        
        // Reload data
        reloadData()
        
    }
    
    @IBAction func selectAllButtonPressed(sender: NSButton) {
        toggleAllCheckboxes(NSOnState)
    }
    
    @IBAction func unselectAllButtonPressed(sender: NSButton) {
        toggleAllCheckboxes(NSOffState)
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
        
        var cell: AnyObject? = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self)
        
        if tableColumn!.identifier == "PasswordColumn" {
            if let view = cell as? NSTableCellView {
                let password = self.passwords[row]
                view.textField!.stringValue = password.value
                
                addToObjectsArray(row, key: "password", value: password.value)
                
                return view
            }
        } else if tableColumn!.identifier == "CheckboxColumn" {
            if let button = cell as? NSButton {
                addToObjectsArray(row, key: "checkbox", value: button)
                
                return button
            }
        }
        
        return cell as? NSTableCellView
    }
}

extension MainViewController: NSTableViewDelegate {
    func tableView(tableView: NSTableView, didAddRowView rowView: NSTableRowView, forRow row: Int) {
        debug("Added row at index \(row)")
    }
}

