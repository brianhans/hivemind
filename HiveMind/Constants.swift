//
//  Constants.swift
//  HiveMind
//
//  Created by Brian Hans on 4/16/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import Foundation

struct Constants {
    static let hiveListTableViewCell = "hiveListTableViewCell"
    static let hiveUserCollectionViewCell = "hiveUserCollectionViewCell"
    static let contactsTableViewCell = "contactsTableViewCell"
    
    static let baseURL: URL = URL(string: "https://hivemind-nabil.herokuapp.com")!
    


    static let hiveName = "hive_name"
    static let hiveToken = "hive_token"
    static let id = "_id"
    static let drones = "drones"
    static let dateCreated = "date_created"
    static let messageSent = "message_sent"
    
    static let numbers = "numbers"
    static let number = "number"
    static let commnd = "command"
    static let options = "options"
    static let text = "text"
    
    static let lastResponse = "last_response"
}

struct CoreDateConstants {
    static let hive = "HiveCD"
    static let hiveUser = "HiveUserCD"
    static let signal = "SignalCD"
    static let signalRef = "signal"
    static let name = "name"
    static let id = "id"
    static let phoneNumber = "phoneNumber"
    static let users = "users"
    static let picture = "pictureData"
    static let status = "status"
    static let title = "title"
    static let options = "options"
    static let statusColors = "statusColors"
}
