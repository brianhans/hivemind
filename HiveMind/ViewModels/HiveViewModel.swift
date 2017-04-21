//
//  HiveViewModel.swift
//  HiveMind
//
//  Created by Brian Hans on 4/16/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import Foundation

class HiveViewModel {
    
    let hive: Hive
    var signal: Signal?
    
    init(hive: Hive) {
        self.hive = hive
    }
    
    func updateHive(completion: @escaping (Hive?) -> Void) {
        HiveProvider.getHive(id: hive.id) { (hive, error) in
            if let error = error {
                print(error)
            }
            
            if let hive = hive {
                self.hive.users = hive.users
                return completion(hive)
            }
            
            completion(nil)
        }
    }
    
}
