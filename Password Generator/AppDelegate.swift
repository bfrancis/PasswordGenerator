//
//  AppDelegate.swift
//  Password Generator
//
//  Created by Brad Francis on 6/09/2015.
//  Copyright (c) 2015 The Friends' School. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    var mainViewController: MainViewController!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        
        
        window.contentView.addSubview(mainViewController.view)
        
        mainViewController.view.frame = (window.contentView as! NSView).bounds
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

