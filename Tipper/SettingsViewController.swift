//
//  SettingsViewController.swift
//  Tipper
//
//  Created by Jonathan Grider on 11/22/17.
//  Copyright © 2017 Jonathan Grider. All rights reserved.
//

import UIKit

let userDefaults = UserDefaults.standard

class SettingsViewController: UIViewController {
    
    // Default tip components
    @IBOutlet weak var defaultTipLabel: UILabel!
    @IBOutlet weak var tipSegmentController: UISegmentedControl!
    
    // Dark Mode components
    @IBOutlet weak var colorSwitch: UISwitch!
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var darkModeView: UIView!
    @IBOutlet weak var settingsBar: UINavigationItem!
    
    /* parent items */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load user defaults
        
        // See if dark mode is enabled, update switch as needed
        let isDark = userDefaults.bool(forKey: "darkMode")
        isDark ? colorSwitch.setOn(true, animated: false) : colorSwitch.setOn(false, animated: false)
        switchColorMode(self)
        
        // Obtain default tip amount & update controller
        tipSegmentController.selectedSegmentIndex = userDefaults.integer(forKey: "tipIndex")
        
        tipSegmentController.isEnabled = true
        tipSegmentController.tintColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchColorMode(_ sender: Any) {
        
        if colorSwitch.isOn {
            
            // Update userDefaults
            userDefaults.set(true, forKey: "darkMode")
            
            // Update view components
            self.view.backgroundColor = .black
            view.tintColor = .black
            darkModeView.backgroundColor = .black
            darkModeLabel.textColor = .white
            defaultTipLabel.textColor = .white
            
            // Update navigation area
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.barTintColor = UIColor.black
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
            self.navigationController?.navigationBar.barStyle = .black
        
        } else {
            
            // Update userDefaults
            userDefaults.set(false, forKey: "darkMode")
            
            // Update view components
            self.view.backgroundColor = .white
            view.tintColor = .white
            darkModeView.backgroundColor = .white
            darkModeLabel.textColor = .black
            defaultTipLabel.textColor = .black
            
            // Update navigation area
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
            self.navigationController?.navigationBar.barStyle = .default
            
            
        }
        
//        // Synchronize updated user defaults
//        userDefaults.synchronize()
        
    }

    @IBAction func updateDefaultTip(_ sender: Any) {
        
        userDefaults.set(tipSegmentController.selectedSegmentIndex, forKey: "tipIndex")
        
    }
}
