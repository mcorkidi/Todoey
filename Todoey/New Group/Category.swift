//
//  Category.swift
//  Todoey
//
//  Created by Moises Corkidi on 4/2/19.
//  Copyright © 2019 Moises Corkidi. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
    
}
