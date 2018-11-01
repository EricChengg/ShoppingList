//
//  Item.swift
//  ShoppingListApp
//
//  Created by Eric Cheng on 19/09/2018.
//  Copyright © 2018 Eric Cheng. All rights reserved.
//

import Foundation
public class Item{
    public var itemKey:Int
    public var itemName:String
    public var itemPrice:Double
    public var itemType:String
    public var quantity:Int
    
    public init(){
        self.itemKey = 0
        self.itemName = ""
        self.itemPrice = 0.0
        self.itemType = ""
        self.quantity = 0
    }
    public init(key:Int, name:String, price:Double, type:String, quantity:Int){
        self.itemKey = key
        self.itemName = name
        self.itemPrice = price
        self.itemType = type
        self.quantity = quantity
    }
    
    
}
