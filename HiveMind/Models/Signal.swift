//
//  Signal.swift
//  HiveMind
//
//  Created by Brian Hans on 4/16/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import UIKit
import CoreData

struct Signal {
    var title: String
    var options: [String] = []
    var statusColors: [UIColor]
    
    init(title: String, options: [String], statusColors: [UIColor]) {
        self.title = title
        self.options = options
        self.statusColors = statusColors
    }
    
    init?(coreDataObject: NSManagedObject) {
        self.title = coreDataObject.value(forKey: CoreDateConstants.title) as? String ?? ""
        self.options = coreDataObject.value(forKey: CoreDateConstants.options) as? [String] ?? []
        self.statusColors = coreDataObject.value(forKey: CoreDateConstants.statusColors) as? [UIColor] ?? []
    }
    
    
    func getCoreDataObject() -> NSManagedObject?  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDateConstants.signal)
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        let signal: NSManagedObject
        
        //Check to see if this hive already exist and update it if it does or create a new one
        if let signals = try? managedContext.fetch(fetchRequest), signals.count > 0 {
            signal = signals[0]
        } else {
            let entity = NSEntityDescription.entity(forEntityName: CoreDateConstants.signal, in: managedContext)!
            signal = NSManagedObject(entity: entity, insertInto: managedContext)
        }
        
        signal.setValue(title, forKeyPath: CoreDateConstants.title)
        signal.setValue(options, forKey: CoreDateConstants.options)
        signal.setValue(statusColors, forKey: CoreDateConstants.statusColors)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }

        return signal
    }
}
