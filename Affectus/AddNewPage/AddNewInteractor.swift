//
//  AddNewInteractor.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import Foundation

protocol AddNewInteractorProtocol {
    func saveToCoreData(_ id: UUID, _ selectedDate: Date, _ givenText: String, _ selectedEmoji: Int, _ selectedEmotions: String, _ selectedActivies: String)
    func fetchCoreData(completion: (_ listData: [AddNewEntity]) -> Void)
}

class AddNewInteractor: AddNewInteractorProtocol {
    
    weak var presenter: AddNewInteractorOutputProtocol?
    var addNewEntityList: AddNewEntityList?
    var addNewEntity: AddNewEntity?
    var sampleEntityList: AddNewEntityListSample?
    
    func addNewDataObserver() {
        NotificationCenter.default.post(name: .didSavedNewData, object: nil)
    }
    
    func saveToCoreData(_ id: UUID, _ selectedDate: Date, _ givenText: String, _ selectedEmoji: Int, _ selectedEmotions: String, _ selectedActivies: String) {
        CoreDataManager.shared.saveData(newEntitySample: AddNewEntity(id: id, moodDate: selectedDate, notesText: givenText, moodEmoji: selectedEmoji, moodDescribe: selectedEmotions, activitySelection: selectedActivies)) {
            self.presenter?.didSaveDataWithSuccess()
            self.addNewDataObserver()
        } onError: {
            self.presenter?.didSaveDataWithError()
        }
    }
    
    func saveToCoreDataSample(_ id: UUID, _ selectedDate: Date, _ givenText: String, _ selectedEmoji: Int, _ selectedEmotions: String, _ selectedActivies: String) {
        CoreDataManager.shared.saveData(newEntitySample: AddNewEntity(id: id, moodDate: selectedDate, notesText: givenText, moodEmoji: selectedEmoji, moodDescribe: selectedEmotions, activitySelection: selectedActivies)) {
            self.presenter?.didSaveDataWithSuccess()
            self.addNewDataObserver()
        } onError: {
            self.presenter?.didSaveDataWithError()
        }
    }
    
    func fetchCoreData(completion: (_ listData: [AddNewEntity]) -> Void) {
        CoreDataManager.shared.loadData { addNewEntityListSample in
            completion(addNewEntityListSample.sampleEntity)
        }
    }
}
