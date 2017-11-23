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
    @IBOutlet weak var tipTotalView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        tipTotalView.alpha = 0
        
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
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: Any) {
        // End keyboard editing
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        
        // Update the most recent bill value
        defaults.set(Double(billField.text!) ?? 0, forKey: "bill")
        
        // Compute the tip and total
        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        // Animate tip and total views
        UIView.animate(withDuration: 0.4, animations:{
            if (self.billField.text!.isEmpty) {
                self.tipTotalView.alpha = 0
            } else {
                self.tipTotalView.alpha = 1
            }
        });
        
        // Update the tip and total labels
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
    }
    
    func updateColors() {
        
        let isDark = defaults.bool(forKey: "darkMode")
        
        if isDark {
            
            //tipLabel.textColor = .white
            
            tipTextLabel.textColor = .white
            totalTextLabel.textColor = .white
            totalLabel.textColor = .white
            billField.textColor = .white
            billField.backgroundColor = .black
            billField.tintColor = .lightGray
            billField.textColor = .white
            billField.keyboardAppearance = UIKeyboardAppearance.dark
            tipTotalView.backgroundColor = .black
            self.view.backgroundColor = .black
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
            self.navigationController?.navigationBar.barStyle = .black
            
        } else {
            
            //billLabel.textColor = .black
            //tipLabel.textColor = .black
            
            tipTextLabel.textColor = .black
            totalTextLabel.textColor = .black
            totalLabel.textColor = .black
            billField.textColor = .black
            billField.backgroundColor = .white
            billField.textColor = .black
            billField.keyboardAppearance = UIKeyboardAppearance.light
            tipTotalView.backgroundColor = .white
            self.view.backgroundColor = .white
            
            /* update navbar */
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
            self.navigationController?.navigationBar.barStyle = .default
            
        }
        
    }
    
    func updateToDefaultTips() {
        
        // Update the default tip selector
        let tipIndex = defaults.integer(forKey: "tipIndex")
        tipControl.selectedSegmentIndex = tipIndex
    }
    
    
}

