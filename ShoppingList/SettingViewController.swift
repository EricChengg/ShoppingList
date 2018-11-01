//
//  SettingViewController.swift
//  ShoppingList
//
//  Created by Eric Cheng on 07/10/2018.
//  Copyright © 2018 Eric Cheng. All rights reserved.
//
import UIKit
class SettingViewController: UIViewController{
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    
    @IBOutlet weak var fontColorButton: UIButton!
    
    @IBOutlet weak var backgroundColorButton: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var setcolor:UIColor!
    
    @IBOutlet var backgorundView: UIView!

    @IBAction func fontColorButton(_ sender: Any) {
        fontColorButton.backgroundColor = UIColor.black
        fontColorButton.tintColor = UIColor.white
        
        backgroundColorButton.backgroundColor = UIColor.white
        backgroundColorButton.tintColor = UIColor.blue
    }

    @IBAction func backgroundButton(_ sender: Any) {
        backgroundColorButton.backgroundColor = UIColor.black
        backgroundColorButton.tintColor = UIColor.white
        
        fontColorButton.backgroundColor = UIColor.white
        fontColorButton.tintColor = UIColor.blue
    }
    
    var redColor: Float = 0
    var blueColor: Float = 0
    var greenColor: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func redColor(_ sender: Any) {
        if backgroundColorButton.backgroundColor == UIColor.black{
            changeBackgroundColor()
        }
        if fontColorButton.backgroundColor == UIColor.black{
            changeLabelColor()
        }
    }
    
    @IBAction func blueColor(_ sender: Any) {
        if backgroundColorButton.backgroundColor == UIColor.black{
            changeBackgroundColor()
        }
        if fontColorButton.backgroundColor == UIColor.black{
            changeLabelColor()
        }
    }
    
    @IBAction func greenColor(_ sender: Any) {
        if backgroundColorButton.backgroundColor == UIColor.black{
            changeBackgroundColor()
        }
        if fontColorButton.backgroundColor == UIColor.black{
            changeLabelColor()
        }
    }
    
    
    
    func changeLabelColor(){
        redLabel.textColor = getColor()
        greenLabel.textColor = getColor()
        blueLabel.textColor = getColor()
        changeLabelNumber()
    }
    
    func changeBackgroundColor(){
        backgorundView.backgroundColor = getColor()
        
        changeLabelNumber()
    }
    
    
    
    func changeLabelNumber(){
        redLabel.text = "Red: " + String(format: "%0.0f", (redColor * 255))
        greenLabel.text = "Green: " + String(format: "%0.0f", (greenColor * 255))
        blueLabel.text = "Blue: " + String(format: "%0.0f", (blueColor * 255))
    }
    
    func getColor() -> UIColor{
        redColor = redSlider.value
        blueColor = blueSlider.value
        greenColor = greenSlider.value
        let theColor = UIColor(red: CGFloat(redColor), green: CGFloat(greenColor), blue: CGFloat(blueColor), alpha: 1.0)
        return theColor
    }
    
    // passing color to firstViewController.
    @IBAction func confirmButton(_ sender: Any) {
        appDelegate.newColor = getColor()
        changeLabelNumber()
    }
    
    @IBAction func changeBackgroundColor(_ sender: UIButton) {
        
        appDelegate.backgroundColor = getColor()
        changeLabelNumber()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! FirstViewController
        vc.theColor = self.setcolor
    }
    
    @IBAction func resetButton(_ sender: Any) {
        backgorundView.backgroundColor = UIColor.white
        fontColorButton.tintColor = UIColor(displayP3Red: 0, green: 122/255, blue:1.0 , alpha: 1.0)
        fontColorButton.backgroundColor = UIColor.white
        
        backgroundColorButton.tintColor = UIColor(displayP3Red: 0, green: 122/255, blue:1.0, alpha: 1.0)
        backgroundColorButton.backgroundColor = UIColor.white
        
        redLabel.textColor = UIColor.black
        blueLabel.textColor = UIColor.black
        greenLabel.textColor = UIColor.black
    }
}

