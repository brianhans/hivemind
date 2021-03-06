//
//  Router.swift
//  HiveMind
//
//  Created by Brian Hans on 4/19/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import Foundation
import Alamofire


enum HiveRouter: URLRequestConvertible {
    case createHive(name: String)
    case addToHive(id: String, numbers: [String])
    case removeFromHive(id: String, numbers: [String])
    case sendSignal(id: String, command: String, options: [String])
    case getHive(id: String)
    
    var method: HTTPMethod {
        switch self {
        case .createHive, .addToHive, .sendSignal:
            return .post
        case .getHive:
            return .get
        case .removeFromHive:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case let .addToHive(id, _), let .removeFromHive(id, _):
            return "/drones/\(id)"
        case .createHive:
            return "/hives"
        case let .getHive(id):
            return "/hives/\(id)"
        case let .sendSignal(id, _, _):
            return "/signals/\(id)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .addToHive(_, numbers), let .removeFromHive(_, numbers):
            return [Constants.numbers: numbers]
        case let .sendSignal(_, command, options):
            return [Constants.commnd: command, Constants.options: options]
        case let .createHive(name):
            return [Constants.hiveName: name, Constants.dateCreated: Date().timeIntervalSince1970]
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = Constants.baseURL
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch method {
        case .post, .delete:
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        default:
            return try URLEncoding.methodDependent.encode(urlRequest, with: parameters)
        }
        
        
    }
    
}
