//
//  CoreDataManager.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 10.08.2022.
//

import UIKit
import CoreData

struct CoreDataManager {
    static var shared = CoreDataManager()

    func saveData(newEntitySample: AddNewEntity, onSuccess: () -> (), onError: () -> ()) {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let addNewMood = NSEntityDescription.insertNewObject(forEntityName: "AffectusMood", into: context)
        
        addNewMood.setValue(newEntitySample.id, forKey: "id")
        addNewMood.setValue(newEntitySample.moodDate, forKey: "moodDate")
        addNewMood.setValue(newEntitySample.notesText, forKey: "notesText")
        addNewMood.setValue(newEntitySample.moodEmoji, forKey: "moodEmoji")
        addNewMood.setValue(newEntitySample.moodDescribe, forKey: "moodDescribe")
        addNewMood.setValue(newEntitySample.activitySelection, forKey: "activitySelection")
        
        do {
            try context.save()
            onSuccess()
        } catch {
            onError()
        }
    }

    func loadData(completion: ((_ addNewEntityListSample: AddNewEntityListSample) -> ())) {

        var addNewEntityList = AddNewEntityListSample()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AffectusMood")
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                
                addNewEntityList.sampleEntity.removeAll()

                for result in results as! [NSManagedObject] {
                    
                    if let id = result.value(forKey: "id") as? UUID,
                       let moodDate = result.value(forKey: "moodDate") as? Date,
                       let notesText = result.value(forKey: "notesText") as? String,
                       let moodEmoji = result.value(forKey: "moodEmoji") as? Int,
                       let moodDescribe = result.value(forKey: "moodDescribe") as? String,
                       let activitySelection = result.value(forKey: "activitySelection") as? String {
                        addNewEntityList.sampleEntity.append(AddNewEntity(id: id, moodDate: moodDate, notesText: notesText, moodEmoji: moodEmoji, moodDescribe: moodDescribe, activitySelection: activitySelection))
                    }
                }
            }
            completion(addNewEntityList)

        } catch {
            completion(addNewEntityList) //TODO: Take a look later!!!
        }
    }
    
    func deleteItem(chosenId: UUID, completion: ((_ addNewEntity: AddNewEntity) -> ()), onSuccess: () -> (), onError: () -> ()) {

        var addNewEntity = AddNewEntity()
        addNewEntity.id = chosenId

        let appDelagate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelagate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AffectusMood")
        let idString = chosenId.uuidString

        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let results = try context.fetch(fetchRequest)
            if results.count >= 0 {

                for result in results as! [NSManagedObject] {
                    if let id = result.value(forKey: "id") as? UUID {
                        if id == chosenId {
                            context.delete(result)
                            completion(addNewEntity)
                            do {
                                try context.save()
                                onSuccess()
                            } catch {
                                onError()
                            }

                            break
                        }
                    }
                }
            }

        } catch {

        }
    }
    
    func deleteAllItems(completion: ((_ addNewEntity: AddNewEntityList) -> ()), onSuccess: () -> (), onError: () -> ()) {

        let addNewEntity = AddNewEntityList()

        let appDelagate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelagate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AffectusMood")

        fetchRequest.returnsObjectsAsFaults = false

        do {
            let results = try context.fetch(fetchRequest)
            if results.count >= 0 {
                
                for result in results as! [NSManagedObject] {
                    context.delete(result)
                    completion(addNewEntity)
                    do {
                        try context.save()
                        onSuccess()
                    } catch {
                        onError()
                    }
                }
            }

        } catch {

        }
    }
}
