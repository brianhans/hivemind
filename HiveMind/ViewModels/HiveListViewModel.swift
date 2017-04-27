//
//  HiveListViewModel.swift
//  HiveMind
//
//  Created by Brian Hans on 4/16/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import Foundation

class HiveListViewModel {
    
    var hives: [Hive] = []

    
    func deleteHive(at index: Int) -> Bool {
        let hiveIndex = index - 1
        guard hiveIndex >= 0 && hiveIndex < hives.count else { return false }
        
        if hives[hiveIndex].delete() {
            hives.remove(at: hiveIndex)
            return true
        }
        
        return false
    }
}
