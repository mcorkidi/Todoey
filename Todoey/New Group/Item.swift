//
//  Item.swift
//  Todoey
//
//  Created by Moises Corkidi on 4/2/19.
//  Copyright © 2019 Moises Corkidi. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
