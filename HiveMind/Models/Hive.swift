//
//  Hive.swift
//  HiveMind
//
//  Created by Brian Hans on 4/16/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import Foundation

class Hive {
    let id: String
    var name: String
    var users: [HiveUser] = []
    
    init(id: String, name: String, users: [HiveUser] = []) {
        self.id = id
        self.name = name
    }
}
