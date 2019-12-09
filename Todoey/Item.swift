//
//  File.swift
//  Todoey
//
//  Created by Jayesh Patel on 11/30/19.
//  Copyright © 2019 nairit. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var Title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated = Date()
    
    var parentCategory = LinkingObjects(fromType:Category.self, property: "items")
    
}
