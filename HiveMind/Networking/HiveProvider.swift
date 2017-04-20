//
//  HiveProvider.swift
//  HiveMind
//
//  Created by Brian Hans on 4/19/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import Foundation

class HiveProvider {
    
    static func createHive(name: String, completion: (Hive?, Error?) -> Void) {
    
    }
    
    static func getHive(id: String, completion: (Hive) -> Void) {
    
    }
    
    static func addToHive(id: String, numbers: [String], completion: ((Error?) -> Void)? = nil) {
        
    }
    
    static func removeFromHive(id: String, numbers: [String], completion: ((Error?) -> Void)? = nil) {
        
    }
    
    static func sendSignal(id: String, command: String, options: [String], completion: ((Error?) -> Void)? = nil) {
    
    }
}
