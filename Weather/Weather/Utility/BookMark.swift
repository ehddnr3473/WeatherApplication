//
//  BookMark.swift
//  Weather
//
//  Created by 김동욱 on 2022/08/21.
//

import Foundation
import UIKit
import CoreData

struct BookMark {
    static func fetchCity() -> [NSManagedObject]? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persistentContainer.viewContext else { return nil }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: AppText.ModelText.entityName)
        let resultArray = try? context.fetch(fetchRequest)
        
        return resultArray
    }
    
    static func saveCity(name: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persistentContainer.viewContext else { return }

        guard let entity = NSEntityDescription.entity(forEntityName: AppText.ModelText.entityName, in: context) else { return }

        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(name, forKey: AppText.ModelText.attributeName)
        
        try? context.save()
    }
    
    static func deleteCity(name: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persistentContainer.viewContext else { return }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "City")

        fetchRequest.predicate = NSPredicate(format: "name = %@ ", name)

        guard let result = try? context.fetch(fetchRequest) else { return }
        guard let objectToDelete = result[0] as? NSManagedObject else { return }
        context.delete(objectToDelete)
        try? context.save()
    }
}
