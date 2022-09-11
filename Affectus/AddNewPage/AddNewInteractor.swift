//
//  AddNewInteractor.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import Foundation

protocol AddNewInteractorProtocol {
    func saveToCoreData(_ id: UUID, _ selectedDate: Date, _ givenText: String, _ selectedEmoji: Int, _ selectedEmotions: String, _ selectedActivies: String)
    func fetchCoreData(_ selectedId: UUID, _ localIndex: Int)
    func saveToCoreDataWithEdit(_ id: UUID, _ selectedDate: Date, _ givenText: String, _ selectedEmoji: Int, _ selectedEmotions: String, _ selectedActivies: String, _ selectedId: UUID, _ localIndex: Int)
}

class AddNewInteractor: AddNewInteractorProtocol {
    
    weak var presenter: AddNewInteractorOutputProtocol?
    var addNewEntityList: AddNewEntityList?
    var addNewEntity: AddNewEntity?
    
    func addNewDataObserver() {
        NotificationCenter.default.post(name: .didSavedNewData, object: nil)
    }
    
    func saveToCoreData(_ id: UUID, _ selectedDate: Date, _ givenText: String, _ selectedEmoji: Int, _ selectedEmotions: String, _ selectedActivies: String) {
        CoreDataManager.shared.saveData(id: id, moodDate: selectedDate, notesText: givenText, moodEmoji: selectedEmoji, moodDescribe: selectedEmotions, activitySelection: selectedActivies) {
            self.presenter?.didSaveDataWithSuccess()
            self.addNewDataObserver()
        } onError: {
            self.presenter?.didSaveDataWithError()
        }
    }
    
    func saveToCoreDataWithEdit(_ id: UUID, _ selectedDate: Date, _ givenText: String, _ selectedEmoji: Int, _ selectedEmotions: String, _ selectedActivies: String, _ selectedId: UUID, _ localIndex: Int) {
//        CoreDataManager.shared.deleteItem(chosenId: selectedId) { addNewEntity in
//            self.addNewEntity = addNewEntity
//            addNewEntityList?.moodDescribeArray.remove(at: localIndex)
//            addNewEntityList?.activitySelectionArray.remove(at: localIndex)
//            addNewEntityList?.moodDateArray.remove(at: localIndex)
//            addNewEntityList?.moodEmojiArray.remove(at: localIndex)
//            addNewEntityList?.notesTextArray.remove(at: localIndex)
//            addNewEntityList?.idArray.remove(at: localIndex)
//        } onSuccess: {
//
//        } onError: {
//            print("something went wrong")
//        }

    }
    
    func fetchCoreData(_ selectedId: UUID, _ localIndex: Int) {
        CoreDataManager.shared.loadData { [weak self] addNewEntityList in
            guard let self = self else { return }
            self.addNewEntityList = addNewEntityList
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self else { return }
                self.presenter?.notifyEditableDataFetched(addNewEntityList, localIndex)
            }
        }
    }
}
