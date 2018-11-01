//
//  SecondViewController.swift
//  ShoppingList
//
//  Created by Eric Cheng on 06/10/2018.
//  Copyright © 2018 Eric Cheng. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var secondView: UIView!
    
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var quantityTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    var selectedValue: String = "Groceries"
    
    @IBOutlet weak var valueStepper: UIStepper!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var db:OpaquePointer? = nil

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return appDelegate.types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return appDelegate.types[row] as String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = appDelegate.types[row]
    }
    
    
    
    @IBAction func addItemButton(_ sender: Any) {
        let newItem = Item()
        if errorMassage() == false{
        }
        else{
        newItem.itemKey = appDelegate.itemArray.count + 1
        insertQuery(name: nameTextField.text!, type: selectedValue, price: (priceTextField.text! as NSString).doubleValue, quantity: (quantityTextField.text! as NSString).integerValue)
        appDelegate.itemArray.append(newItem)
        }
    }
    
    
    
    func errorMassage() -> Bool{
        if nameTextField.text! == ""{
            let alert = UIAlertController(title: "Item name error.", message:"Item name should not be blank.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if priceTextField.text! == ""{
            let alert = UIAlertController(title: "Item price error.", message:"Item price should not be blank.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if quantityTextField.text == ""{
            let alert = UIAlertController(title: "Quantity error.", message:"Quantity should not be zero.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else {
            return true
        }
    }
    
    @IBAction func resetButton(_ sender: Any) {
        nameTextField.text = ""
        
        quantityTextField.text = ""
        priceTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        valueStepper.autorepeat = true
        valueStepper.value = 0
        
        valueStepper.minimumValue = 0
        valueStepper.maximumValue = 9999
        valueStepper.stepValue = 1
        
        valueStepper.addTarget(
            self,
            action:
            #selector(self.onStepperChange), for: .valueChanged
            )

    }
    
    @objc func onStepperChange() {
        quantityTextField.text = "\(Int(valueStepper.value))"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if appDelegate.backgroundColor != nil{
            secondView.backgroundColor = appDelegate.backgroundColor
        }
    }
    
    func insertQuery(name:String, type:String, price:Double, quantity:Int){
        let insertSQL = "INSERT INTO item(ItemName, ItemPrice, ItemType, Quantity) values('\(name)','\(price)','\(type)', '\(quantity)')"
        print(insertSQL)
        var queryStatement: OpaquePointer? = nil
        if(sqlite3_open(appDelegate.getDBPath(), &db) == SQLITE_OK){
            print("Opened connection to database.")
            
            if(sqlite3_prepare(db, insertSQL, -1, &queryStatement, nil)==SQLITE_OK){
                if(sqlite3_step(queryStatement)==SQLITE_DONE){
                    print("Record Inserted")
                }
                else{
                    print("Fail to insert")
                }
                sqlite3_finalize(queryStatement)
            }
            else{
                print("Insert statement could not be prepared")
            }
            sqlite3_close(db)
        }
        else{
            print("Unable to open database")
        }
    }
    
    

}

