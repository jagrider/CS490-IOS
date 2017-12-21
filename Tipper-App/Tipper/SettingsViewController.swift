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
  @IBOutlet weak var darkModeSwitch: UISwitch!
  @IBOutlet weak var darkModeLabel: UILabel!
  @IBOutlet weak var darkModeView: UIView!
  @IBOutlet weak var settingsBar: UINavigationItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // See if dark mode is enabled, update switch as needed
    let isDark = userDefaults.bool(forKey: "darkMode")
    isDark ? darkModeSwitch.setOn(true, animated: false) : darkModeSwitch.setOn(false, animated: false)
    switchColorMode(self)
    
    // Update segment controller for default tips
    tipSegmentController.selectedSegmentIndex = userDefaults.integer(forKey: "tipIndex")
    tipSegmentController.isEnabled = true
    tipSegmentController.tintColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func switchColorMode(_ sender: Any) {
    if darkModeSwitch.isOn {
      // Update userDefaults
      userDefaults.set(true, forKey: "darkMode")
      
      // Update view components
      view.backgroundColor = .black
      view.tintColor = .black
      darkModeView.backgroundColor = .black
      darkModeLabel.textColor = .white
      defaultTipLabel.textColor = .white
      
      // Update navigation area
      navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
      navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
      navigationController?.navigationBar.shadowImage = UIImage()
      navigationController?.navigationBar.barTintColor = .black
      navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
      navigationController?.navigationBar.barStyle = .black
    } else {
      
      // Update userDefaults
      userDefaults.set(false, forKey: "darkMode")
      
      // Update view components
      view.backgroundColor = .white
      view.tintColor = .white
      darkModeView.backgroundColor = .white
      darkModeLabel.textColor = .black
      defaultTipLabel.textColor = .black
      
      // Update navigation area
      navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
      navigationController?.navigationBar.shadowImage = UIImage()
      navigationController?.navigationBar.barTintColor = .white
      navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
      navigationController?.navigationBar.barStyle = .default
    }
  }
  
  @IBAction func updateDefaultTip(_ sender: Any) {
    userDefaults.set(tipSegmentController.selectedSegmentIndex, forKey: "tipIndex")
  }
}
