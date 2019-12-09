//
//  Category.swift
//  Todoey
//
//  Created by Jayesh Patel on 11/30/19.
//  Copyright © 2019 nairit. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    
    let items = List<Item>()
    
}
