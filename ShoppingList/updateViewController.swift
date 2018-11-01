//
//  updateViewController.swift
//  ShoppingList
//
//  Created by Eric Cheng on 31/10/2018.
//  Copyright © 2018 Eric Cheng. All rights reserved.
//

import UIKit

class updateViewController: UIAlertController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    
    var name:String?
    var price:Double?
    var quantity:Int?
    
    @IBAction func updateButton(_ sender: Any) {
    }
    
    @IBAction func cancelButton(_ sender: Any) {
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = name
        priceTextField!.text = String(format:"%f",price!)
        quantityTextField!.text = String(format:"%d",quantity!)
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
