//
//  BookmarkService.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/21.
//

import Foundation
import UIKit
import CoreData

struct BookmarkService {
    static func fetchCity() -> [NSManagedObject]? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persistentContainer.viewContext else { return nil }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataModel.entityName)
        let resultArray = try? context.fetch(fetchRequest)
        
        return resultArray
    }
    
    static func saveCity(name: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persistentContainer.viewContext else { return }

        guard let entity = NSEntityDescription.entity(forEntityName: CoreDataModel.entityName, in: context) else { return }

        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(name, forKey: CoreDataModel.attributeName)
        
        try? context.save()
    }
    
    static func deleteCity(name: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persistentContainer.viewContext else { return }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "City")

        fetchRequest.predicate = NSPredicate(format: "name = %@ ", name)

        guard let result = try? context.fetch(fetchRequest) else { return }
        guard let objectToDelete = result[.zero] as? NSManagedObject else { return }
        context.delete(objectToDelete)
        
        try? context.save()
    }
}

enum CoreDataModel {
    static let entityName = "City"
    static let attributeName = "name"
}
