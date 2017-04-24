//
//  HiveUser.swift
//  HiveMind
//
//  Created by Brian Hans on 4/16/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import Contacts

class HiveUser: Equatable {
    let name: String
    let phoneNumber: String
    let picture: UIImage?
    var status: Int
    
    init?(contact: CNContact) {
        guard contact.phoneNumbers.count > 0 else { return nil }
        
        var image: UIImage? = nil
        if let imageData = contact.imageData {
            image = UIImage(data: imageData)
        }
        
        self.picture = image
        self.name = "\(contact.givenName) \(contact.familyName)"
        self.phoneNumber = contact.phoneNumbers[0].value.stringValue.cleanPhoneNumber()
        self.status = 0
    }
    
    init(name: String, phoneNumber: String, picture: UIImage?, status: Int = 0) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.picture = picture
        self.status = status
    }
    
    convenience init?(json: JSON) {
        guard let number = json[Constants.number].string else { return nil }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDateConstants.hiveUser)
        fetchRequest.predicate = NSPredicate(format: "phoneNumber == %@", number)
        
        
        
        //Check to see if this user already exist and update it if it does or create a new one
        if let users = try? managedContext.fetch(fetchRequest), users.count > 0 {
            let user = users[0]
            self.init(coreDataObject: user)
            let statusString = json[Constants.lastResponse].string ?? ""
            self.status = Int(statusString) ?? 0
        } else {
            return nil
        }
    }
    
    init(coreDataObject: NSManagedObject) {
        self.name = coreDataObject.value(forKey: CoreDateConstants.name) as? String ?? ""
        self.phoneNumber = coreDataObject.value(forKey: CoreDateConstants.phoneNumber) as? String ?? ""
        if let imageData = coreDataObject.value(forKey: CoreDateConstants.picture) as? Data {
            self.picture = UIImage(data: imageData)
        } else {
            self.picture = nil
        }
        
        self.status = coreDataObject.value(forKey: CoreDateConstants.status) as? Int ?? 0
    }
    
    func getCoreDataObject() -> NSManagedObject? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDateConstants.hiveUser)
        fetchRequest.predicate = NSPredicate(format: "phoneNumber == %@", phoneNumber)
        
        let user: NSManagedObject
        
        //Check to see if this user already exist and update it if it does or create a new one
        if let users = try? managedContext.fetch(fetchRequest), users.count > 0 {
            user = users[0]
        } else {
            let entity = NSEntityDescription.entity(forEntityName: CoreDateConstants.hiveUser, in: managedContext)!
            user = NSManagedObject(entity: entity, insertInto: managedContext)
        }
        
        let cleanedNumber = phoneNumber.cleanPhoneNumber()
        
        user.setValue(name, forKey: CoreDateConstants.name)
        user.setValue(cleanedNumber, forKey: CoreDateConstants.phoneNumber)
        user.setValue(status, forKey: CoreDateConstants.status)
        
        if let image = picture {
            user.setValue(UIImagePNGRepresentation(image), forKey: CoreDateConstants.picture)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
        
        return user
    }
    
    static func ==(lhs: HiveUser, rhs: HiveUser) -> Bool {
        return lhs.phoneNumber == rhs.phoneNumber
    }

}
