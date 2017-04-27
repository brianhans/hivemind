//
//  Hive.swift
//  HiveMind
//
//  Created by Brian Hans on 4/16/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class Hive {
    let id: String
    var name: String
    var users: [HiveUser] = []
    var signal: Signal?
    
    init(id: String, name: String, users: [HiveUser] = []) {
        self.id = id
        self.name = name
    }
    
    init?(json: JSON) {
        guard let id = json[Constants.id].string, let name = json[Constants.hiveName].string else { return nil }
        
        self.id = id
        self.name = name
        self.users = []
        
        if let drones = json[Constants.drones].array {
            self.users = drones.flatMap(HiveUser.init)
        }
        
    }
    
    init?(coreDataObject: NSManagedObject) {
        guard let id = coreDataObject.value(forKey: CoreDateConstants.id) as? String else { return nil }
        self.id = id
        self.name = coreDataObject.value(forKey: CoreDateConstants.name) as? String ?? ""
        let userObjects = coreDataObject.value(forKey: CoreDateConstants.users) as? [NSManagedObject] ?? []
        if let signalObject = coreDataObject.value(forKey: CoreDateConstants.signalRef) as? NSManagedObject {
            self.signal = Signal(coreDataObject: signalObject)
        }
        
        self.users = userObjects.flatMap(HiveUser.init)
    }
    
    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDateConstants.hive)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        let hive: NSManagedObject
        
        //Check to see if this hive already exist and update it if it does or create a new one
        if let hives = try? managedContext.fetch(fetchRequest), hives.count > 0 {
            hive = hives[0]
        } else {
            let entity = NSEntityDescription.entity(forEntityName: CoreDateConstants.hive, in: managedContext)!
            hive = NSManagedObject(entity: entity, insertInto: managedContext)
        }
        
        hive.setValue(name, forKeyPath: CoreDateConstants.name)
        hive.setValue(id, forKey: CoreDateConstants.id)
        let userRef = hive.mutableSetValue(forKey: CoreDateConstants.users)
        //Remove all the old users
        userRef.removeAllObjects()
        userRef.addObjects(from: users.flatMap{$0.getCoreDataObject()})
        
        if let signalObject = signal?.getCoreDataObject() {
            hive.setValue(signalObject, forKey: CoreDateConstants.signalRef)
        }

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func delete() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDateConstants.hive)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        //Check to see if this hive already exist and update it if it does or create a new one
        if let hives = try? managedContext.fetch(fetchRequest), hives.count > 0 {
            let hive = hives[0]
            
            managedContext.delete(hive)
            
            do {
                try managedContext.save()
                return true
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        return false
    }
    
    static func getHives() -> [Hive] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDateConstants.hive)
        let hiveObjects = (try? managedContext.fetch(fetchRequest)) ?? []
        
        return hiveObjects.flatMap(Hive.init)
    }
}
