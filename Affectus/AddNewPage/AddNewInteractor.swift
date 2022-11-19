//
//  AddNewInteractor.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import Foundation

protocol AddNewInteractorProtocol {
    func saveToCoreData(_ id: UUID, _ selectedDate: Date, _ givenText: String, _ selectedEmoji: Int, _ selectedEmotions: String, _ selectedActivies: String)
    func fetchCoreData(_ localIndex: Int, _ selectedId: UUID)
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
    
    func fetchCoreData(_ localIndex: Int, _ selectedId: UUID) {
        CoreDataManager.shared.loadData { [weak self] addNewEntityList in
            guard let self = self else { return }
            self.addNewEntityList = addNewEntityList
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                self.presenter?.notifyDidFetchData(addNewEntityList, localIndex, selectedId)
            }
        }
    }
}
