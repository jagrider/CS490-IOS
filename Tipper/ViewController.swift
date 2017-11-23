//
//  ViewController.swift
//  Tipper
//
//  Created by Jonathan Grider on 11/21/17.
//  Copyright © 2017 Jonathan Grider. All rights reserved.
//

import UIKit

let defaults = UserDefaults.standard

class ViewController: UIViewController {

    //@IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var tipTextLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalTextLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Update default tips
        updateDefaultTips()
        
        // Update the amount if within 10 minutes of last opening
        let oldBill = defaults.double(forKey: "bill")
        var oldTime = NSDate.init()
        
        if (defaults.object(forKey: "time") != nil) {
            oldTime = defaults.object(forKey: "time") as! NSDate
        }
        
        if (oldTime.timeIntervalSinceNow <= 600 && oldBill != 0) {
            billField.text = String(format: "%.2f", oldBill)
        }
        
        // Update the colors
        updateColors()
        
        // Bring up the keyboard right away
        billField.keyboardType = UIKeyboardType.decimalPad
        billField.becomeFirstResponder()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Update colors
        updateColors()
        
        // Update tip controller & calculate tip
        updateDefaultTips()
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
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: Any) {
        // End keyboard editing
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        
        defaults.set(Double(billField.text!) ?? 0, forKey: "bill")
        
        //updateColors()
        
        let tipPercentages = [0.15, 0.2, 0.25]
        
        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
//        billField.text = "$" + String(describing: Double(billField.text!) ?? 0)
        
    }
    
    func updateColors() {
        
        let isDark = defaults.bool(forKey: "darkMode")
        
        if isDark {
            
            tipTextLabel.textColor = .white
            tipLabel.textColor = .white
            totalTextLabel.textColor = .white
            totalLabel.textColor = .white
            billField.textColor = .white
//            billField.backgroundColor = UIColor(red:0.16, green:0.16, blue:0.16, alpha:1.0)
            billField.backgroundColor = .black
            billField.tintColor = .lightGray
            billField.textColor = .white
            billField.keyboardAppearance = UIKeyboardAppearance.dark
            self.view.backgroundColor = .black
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
            
        } else {
            
            //billLabel.textColor = .black
            tipTextLabel.textColor = .black
            tipLabel.textColor = .black
            totalTextLabel.textColor = .black
            totalLabel.textColor = .black
            billField.textColor = .black
//            billField.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
            billField.backgroundColor = .white
            billField.textColor = .black
            billField.keyboardAppearance = UIKeyboardAppearance.light
            self.view.backgroundColor = .white
            
            /* update navbar */
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
            
        }
        
    }
    func updateDefaultTips() {
        let tipIndex = defaults.integer(forKey: "tipIndex")
        tipControl.selectedSegmentIndex = tipIndex
    }
    
    
}

