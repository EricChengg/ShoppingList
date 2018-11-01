//
//  FirstViewController.swift
//  ShoppingList
//
//  Created by Eric Cheng on 06/10/2018.
//  Copyright © 2018 Eric Cheng. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var theColor:UIColor! = nil
    
    @IBOutlet var tableView: UITableView!
    
    var db:OpaquePointer? = nil
    
    //for update value
    var newNameTextField: UITextField!
    var newPriceTextField: UITextField!
    var newQuantityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.itemArray.removeAll()
        selectQuery()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)as! ShoppingListCell
        let item = appDelegate.itemArray[indexPath.row]
        cell.itemNameLabel.text = item.itemName
        cell.itemTypeLabel.text = item.itemType
        cell.quantityLabel.text = String(format: "%d", item.quantity)
        cell.priceLabel.text = "$" + String(format:"%.1f", item.itemPrice)
        
        let theColor = appDelegate.newColor
        if theColor != nil{
            cell.itemNameLabel.textColor = theColor
            cell.itemTypeLabel.textColor = theColor
            cell.quantityLabel.textColor = theColor
            cell.priceLabel.textColor = theColor
        }
        else{
            // do nothing
        }
        return cell
    }
// edting the table view
    internal func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let item = appDelegate.itemArray[indexPath.row]
            deleteQuery(itemKey: item.itemKey)
            appDelegate.itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    internal func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let i = appDelegate.itemArray[indexPath.row]
        print(i.itemName)
        let alert = UIAlertController(title: "Update", message: "Enter new item info.", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (textField) in
            self.newNameTextField = textField
            self.newNameTextField.text = i.itemName
        })
        alert.addTextField(configurationHandler: { (textField) in
            textField.text = String(format: "%d", i.quantity)
            self.newPriceTextField = textField
            self.newPriceTextField.text = String(i.itemPrice)
        })
        alert.addTextField(configurationHandler: { (textField) in
            textField.text = String(format: "%0.f", i.itemPrice)
            self.newQuantityTextField = textField
            self.newQuantityTextField.text = String(i.quantity)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let updateButton = UIAlertAction(title: "Update", style: .default, handler: {
            ACTION in
            print("test update")
            print(String(self.newNameTextField.text!))
            print(String(self.newPriceTextField.text!))
            print(String(self.newQuantityTextField.text!))
            self.updateQuery(name:String(self.newNameTextField.text!) , price: (self.newPriceTextField.text! as NSString).doubleValue, quantity: (self.newQuantityTextField.text! as NSString).integerValue, itemKey: i.itemKey)
        })
        alert.addAction(updateButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if appDelegate.backgroundColor != nil{
            tableView.backgroundColor = appDelegate.backgroundColor
        }
        appDelegate.itemArray.removeAll()
        selectQuery()
        tableView.reloadData()
    }
    
    func selectQuery(){
        let selectSQL = "SELECT Itemkey, Itemname, Itemprice, Itemtype, Quantity FROM item"
        var queryStatement:OpaquePointer? = nil
        if sqlite3_open(appDelegate.getDBPath(), &db) == SQLITE_OK{
            print("Opend connection to database")
            
            if(sqlite3_prepare_v2(db, selectSQL, -1, &queryStatement, nil) == SQLITE_OK){
                print("Query Result:")
                
                if(queryStatement != nil){
                    while(sqlite3_step(queryStatement) == SQLITE_ROW){
                        let key = sqlite3_column_int(queryStatement, 0)
                        let name = sqlite3_column_text(queryStatement, 1)
                        
                        let price = sqlite3_column_double(queryStatement, 2)
                        let type = sqlite3_column_text(queryStatement, 3)
                        let quantity = sqlite3_column_int(queryStatement, 4)
                        let i = Item(key: Int(key), name: String(cString:name!), price: Double(price), type: String(cString:type!), quantity: Int(quantity))
                        appDelegate.itemArray.append(i)
                    }
                }
                else{
                    print("query statement is null.")
                }
            }
            else{
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        }
        else{
            print("Unable to open database")
        }
    }
    
    func deleteQuery(itemKey:Int){
        let deleteSQL = "DELETE FROM Item WHERE itemKey = ('\(itemKey)')"
        print(deleteSQL)
        var queryStatement: OpaquePointer? = nil
        if sqlite3_open(appDelegate.getDBPath(), &db) == SQLITE_OK{
            print("Database opened")
            if(sqlite3_prepare(db, deleteSQL, -1, &queryStatement, nil)) == SQLITE_OK{
                if sqlite3_step(queryStatement) == SQLITE_DONE{
                    print("Data deleted")
                }
                else{
                    print("Fail to deleted")
                }
                sqlite3_finalize(queryStatement)
            }
            else{
                print("delete statement could not be prepared")
            }
            sqlite3_close(db)
            
        }
        else{
            print("Unable to open database.")
        }
    }
    
    func updateQuery(name:String, price:Double, quantity:Int, itemKey:Int){
        let updateSQL = "Update Item SET itemName = '\(name)', itemPrice = '\(price)', quantity = '\(quantity)' Where itemKey = '\(itemKey)'"
        print(updateSQL)
        var queryStatement: OpaquePointer? = nil
        if sqlite3_open(appDelegate.getDBPath(), &db) == SQLITE_OK{
            print("Database opened")
            if(sqlite3_prepare(db, updateSQL, -1, &queryStatement, nil)) == SQLITE_OK{
                if sqlite3_step(queryStatement) == SQLITE_DONE{
                    print("Data updated")
                }
                else{
                    print("Fail to updated")
                }
                sqlite3_finalize(queryStatement)
            }
            else{
                print("update statement could not be prepared")
            }
            sqlite3_close(db)
        }
        else{
            print("Unable to open database.")
        }
    }
    
    

    

}

