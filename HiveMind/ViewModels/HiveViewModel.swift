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
        signal = hive.signal
        HiveProvider.getHive(id: hive.id) { [weak self] (hive, error) in
            if let error = error {
                print(error)
            }
            
            if let hive = hive {
                self?.hive.users = hive.users
                hive.signal = self?.signal
                return completion(hive)
            }
            
            completion(nil)
        }
    }
    
}
