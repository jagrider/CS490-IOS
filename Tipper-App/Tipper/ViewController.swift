//
//  ViewController.swift
//  Tipper
//
//  Created by Jonathan Grider on 11/21/17.
//  Copyright © 2017 Jonathan Grider. All rights reserved.
//

import UIKit

let defaults = UserDefaults.standard
let tipPercentages = [0.15, 0.2, 0.25]

class ViewController: UIViewController {
  
  //@IBOutlet weak var billLabel: UILabel!
  @IBOutlet weak var tipTextLabel: UILabel!
  @IBOutlet weak var tipLabel: UILabel!
  @IBOutlet weak var totalTextLabel: UILabel!
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var billField: UITextField!
  @IBOutlet weak var tipControl: UISegmentedControl!
  @IBOutlet weak var tipInfoContainer: UIView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    // Update default tips
    updateToDefaultTips()
    
    // Update the amount if within 10 minutes of last opening
    let oldBill = defaults.double(forKey: "bill")
    var oldTime = NSDate.init()
    if (defaults.object(forKey: "time") != nil) {
      oldTime = defaults.object(forKey: "time") as! NSDate
      
      if (oldTime.timeIntervalSinceNow <= 600 && oldBill != 0) {
        billField.text = String(format: "%.2f", oldBill)
      }
    }
    
    // Set the tip & total view to be invisible
    tipInfoContainer.alpha = 0
    
    // Update the colors
    updateColors()
    
    // Bring up the keyboard right away
    billField.keyboardType = UIKeyboardType.decimalPad
    billField.becomeFirstResponder()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    // Update colors, tip controller & calculate tip
    updateColors()
    updateToDefaultTips()
    calculateTip(self)
    
    // Bring up the keyboard right away
    billField.keyboardType = UIKeyboardType.decimalPad
    billField.becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    
    // Put keyboard away
    view.endEditing(true)
    
    // Save time
    let currTime = NSDate()
    defaults.set(currTime, forKey: "time")
    
    // Save bill amount
    defaults.set(Double(billField.text!) ?? 0, forKey: "bill")
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func onTap(_ sender: Any) {
    // End keyboard editing
    view.endEditing(true)
  }
  
  @IBAction func calculateTip(_ sender: Any) {
    // Update the most recent bill value
    defaults.set(Double(billField.text!) ?? 0, forKey: "bill")
    
    // Compute the tip and total
    let billAmount = Double(billField.text!) ?? 0
    let tipAmount = billAmount * tipPercentages[tipControl.selectedSegmentIndex]
    let billTotal = billAmount + tipAmount
    
    // Animate tip and total views
    UIView.animate(withDuration: 0.4, animations:{
      if (self.billField.text!.isEmpty) {
        self.tipInfoContainer.alpha = 0
      } else {
        self.tipInfoContainer.alpha = 1
      }
    });
    
    // Update the tip and total labels
    tipLabel.text = String(format: "$%.2f", tipAmount)
    totalLabel.text = String(format: "$%.2f", billTotal)
  }
  
  func updateColors() {
    let isDark = defaults.bool(forKey: "darkMode")
    
    if isDark {
      /* update fields */
      tipTextLabel.textColor = .white
      totalTextLabel.textColor = .white
      totalLabel.textColor = .white
      billField.textColor = .white
      billField.backgroundColor = .black
      billField.tintColor = .lightGray
      billField.textColor = .white
      billField.keyboardAppearance = UIKeyboardAppearance.dark
      tipInfoContainer.backgroundColor = .black
      view.backgroundColor = .black
      
      /* update navbar */
      navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
      navigationController?.navigationBar.shadowImage = UIImage()
      navigationController?.navigationBar.barTintColor = .white
      navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
      navigationController?.navigationBar.barStyle = .black
    } else {
      /* update fields */
      tipTextLabel.textColor = .black
      totalTextLabel.textColor = .black
      totalLabel.textColor = .black
      billField.textColor = .black
      billField.backgroundColor = .white
      billField.textColor = .black
      billField.keyboardAppearance = .light
      tipInfoContainer.backgroundColor = .white
      view.backgroundColor = .white
      
      /* update navbar */
      navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
      navigationController?.navigationBar.shadowImage = UIImage()
      navigationController?.navigationBar.barTintColor = .white
      navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
      navigationController?.navigationBar.barStyle = .default
    }
  }
  
  func updateToDefaultTips() {
    // Update the default tip selector
    let tipIndex = defaults.integer(forKey: "tipIndex")
    tipControl.selectedSegmentIndex = tipIndex
  }
}
