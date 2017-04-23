//
//  String+Clean.swift
//  HiveMind
//
//  Created by Brian Hans on 4/23/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import Foundation

extension String {
    func cleanPhoneNumber() -> String {
        var cleanString: String = self
        
        if let regex = try? NSRegularExpression(pattern: "-|\\s|\\(|\\)") {
            let range = NSMakeRange(0, self.characters.count)
            cleanString = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
        }
        
        return cleanString
    }
}
