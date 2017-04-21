//
//  HiveProvider.swift
//  HiveMind
//
//  Created by Brian Hans on 4/19/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HiveProvider {
    
    static func createHive(name: String, completion: @escaping (Hive?, Error?) -> Void) {
        Alamofire.request(HiveRouter.createHive(name: name)).responseJSON { (response) in
            switch response.result{
            case let .success(value):
                let json = JSON(value)
                if let id = json[Constants.id].string {
                    return completion(Hive(id: id, name: name), nil)
                } else {
                    return completion(nil, HiveError.unknown)
                }
            case let .failure(error):
                completion(nil, error)
            }
        }
    }
    
    static func getHive(id: String, completion: @escaping (Hive?, Error?) -> Void) {
        Alamofire.request(HiveRouter.getHive(id: id)).responseJSON { (response) in
            switch response.result{
            case let .success(value):
                let json = JSON(value)
                if let hive = Hive(json: json) {
                    return completion(hive, nil)
                } else {
                    return completion(nil, HiveError.unknown)
                }
            case let .failure(error):
                completion(nil, error)
            }
        }
    }
    
    static func addToHive(id: String, numbers: [String], completion: ((Error?) -> Void)? = nil) {
        Alamofire.request(HiveRouter.addToHive(id: id, numbers: numbers)).responseJSON { (response) in
            switch response.result {
            case let .success(value):
                let json = JSON(value)
                if json[Constants.drones].arrayObject != nil {
                    completion?(nil)
                } else {
                    completion?(HiveError.unknown)
                }
            case let .failure(error):
                completion?(error)
            }
        }
    }
    
    static func removeFromHive(id: String, numbers: [String], completion: ((Error?) -> Void)? = nil) {
        Alamofire.request(HiveRouter.removeFromHive(id: id, numbers: numbers)).responseJSON { (response) in
            switch response.result {
            case let .success(value):
                let json = JSON(value)
                if json[Constants.drones].arrayObject != nil {
                    completion?(nil)
                } else {
                    completion?(HiveError.unknown)
                }
            case let .failure(error):
                completion?(error)
            }
        }
    }
    
    static func sendSignal(id: String, command: String, options: [String], completion: ((Error?) -> Void)? = nil) {
        Alamofire.request(HiveRouter.sendSignal(id: id, command: command, options: options)).responseJSON { (response) in
            switch response.result {
            case let .success(value):
                let json = JSON(value)
                if json[Constants.messageSent].string != nil {
                    completion?(nil)
                } else {
                    completion?(HiveError.unknown)
                }
                
                break
            case let .failure(error):
                completion?(error)
            }
        }
    }
}


enum HiveError: Error {
    case unknown
}
