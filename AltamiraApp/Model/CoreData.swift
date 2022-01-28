//
//  CoreData.swift
//  AltamiraApp
//
//  Created by Ceren Çapar on 25.01.2022.
//

import Foundation
import UIKit
import CoreData

struct CoreDataManagement{
    static func save(value: Int){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            let context = appDelegate.persistentContainer.viewContext
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "Entity", in: context)else{return}
            
            let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
            newValue.setValue(value, forKey: "id")
            
            do{
                try context.save()
            }catch{}
        }
    }
    
    static func retrieveValues(compilation: @escaping ([Int]) ->()){
            var intArray = [Int]()
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
                fetchRequest.returnsObjectsAsFaults = false
                do{
                    let results = try context.fetch(fetchRequest)
                        
                        for result in results as [NSManagedObject]{
                            
                            if let id = result.value(forKey: "id") as? Int{
                                intArray.append(id)
                                compilation(intArray)
                            }
                        }
                }catch{}
        }
 }
    
    
    static func deleteData(id: Int){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
        fetchRequest.returnsObjectsAsFaults = false
        
        if let results = try? context.fetch(fetchRequest){
            if results.count > 0 {
                for result in results {
                    if result.id == id{
                        context.delete(result)
                    }
                            do {
                                try context.save()
                                
                            } catch {
                            }
            }
        }
}
}
}
