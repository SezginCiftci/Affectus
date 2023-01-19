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

    func saveData(id: UUID, moodDate: Date, notesText: String, moodEmoji: Int, moodDescribe: String, activitySelection: String, onSuccess: () -> (), onError: () -> ()) {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let addNewMood = NSEntityDescription.insertNewObject(forEntityName: "AffectusMood", into: context)

        addNewMood.setValue(id, forKey: "id")
        addNewMood.setValue(moodDate, forKey: "moodDate")
        addNewMood.setValue(notesText, forKey: "notesText")
        addNewMood.setValue(moodEmoji, forKey: "moodEmoji")
        addNewMood.setValue(moodDescribe, forKey: "moodDescribe")
        addNewMood.setValue(activitySelection, forKey: "activitySelection")
        
        do {
            try context.save()
            onSuccess()
        } catch {
            onError()
        }
    }


    func loadData(completion: ((_ addNewEntityList: AddNewEntityList) -> ())) {

        var addNewEntityList = AddNewEntityList()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AffectusMood")
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                
                addNewEntityList.idArray.removeAll(keepingCapacity: false)
                addNewEntityList.moodDateArray.removeAll(keepingCapacity: false)
                addNewEntityList.notesTextArray.removeAll(keepingCapacity: false)
                addNewEntityList.moodEmojiArray.removeAll(keepingCapacity: false)
                addNewEntityList.moodDescribeArray.removeAll(keepingCapacity: false)
                addNewEntityList.activitySelectionArray.removeAll(keepingCapacity: false)


                for result in results as! [NSManagedObject] {
                    
                    if let id = result.value(forKey: "id") as? UUID {
                        addNewEntityList.idArray.append(id)
                    }
                    
                    if let moodDate = result.value(forKey: "moodDate") as? Date {
                        addNewEntityList.moodDateArray.append(moodDate)
                    }
                    
                    if let notesText = result.value(forKey: "notesText") as? String {
                        addNewEntityList.notesTextArray.append(notesText)
                    }
                    
                    if let moodEmoji = result.value(forKey: "moodEmoji") as? Int {
                        addNewEntityList.moodEmojiArray.append(moodEmoji)
                    }
                    
                    if let moodDescribe = result.value(forKey: "moodDescribe") as? String {
                        addNewEntityList.moodDescribeArray.append(moodDescribe)
                    }
                    
                    if let activitySelection = result.value(forKey: "activitySelection") as? String {
                        addNewEntityList.activitySelectionArray.append(activitySelection)
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
