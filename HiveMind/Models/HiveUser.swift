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

struct HiveUser {
    let name: String
    let phoneNumber: String
    let picture: UIImage?
    var status: String?
    
    init(name: String, phoneNumber: String, picture: UIImage?, status: String?) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.picture = picture
        self.status = status
    }
    
    init?(json: JSON) {
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
            self = HiveUser(coreDataObject: user)
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
        
        self.status = coreDataObject.value(forKey: CoreDateConstants.status) as? String ?? ""
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
        
        var cleanedNumber = phoneNumber
        if let regex = try? NSRegularExpression(pattern: "-|\\s|\\(|\\)") {
            let range = NSMakeRange(0, cleanedNumber.characters.count)
            cleanedNumber = regex.stringByReplacingMatches(in: cleanedNumber, options: [], range: range, withTemplate: "")
        }
        
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
}
