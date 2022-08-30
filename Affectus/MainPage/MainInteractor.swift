//
//  MainInteractor.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import Foundation

protocol MainInteractorProtocol {
    func fetchCoreDatas()
    func addObservers()
    func removeNotificationObservers()
    func didDeleteItem(_ selectedId: UUID, _ itemIndex: Int)
}

class MainInteractor: MainInteractorProtocol {
    
    weak var presenter: MainInteractorOutputProtocol?
    
    var addNewEntityList: AddNewEntityList?
    var addNewEntity: AddNewEntity?
    
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didNewDataFetched(_ :)),
                                               name: NSNotification.Name("newData"),
                                               object: nil)
    }
    
    func removeNotificationObservers()  {
//        NotificationCenter.default.removeObserver(self,
//                                                  name: NSNotification.Name("newData"),
//                                                  object: nil)
    }
    
    @objc func didNewDataFetched(_ notification: Notification) {
        CoreDataManager.shared.loadData { [weak self] addNewEntityList in
            guard let self = self else { return }
            guard let addNewEntity = self.addNewEntityList else { return }
            DispatchQueue.global(qos: .default).async { [weak self] in
                guard let self = self else { return }
                self.presenter?.didFetchCoreData(addNewEntity)
            }
        }
    }
    
    func fetchCoreDatas() {
        CoreDataManager.shared.loadData { [weak self] addNewEntityList in
            guard let self = self else { return }
            self.addNewEntityList = addNewEntityList
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self else { return }
                self.presenter?.notifyDidFetchData(addNewEntityList)
            }
        }
    }
    
    func didDeleteItem(_ selectedId: UUID, _ itemIndex: Int) {
        CoreDataManager.shared.deleteItem(chosenId: selectedId) { addNewEntity in
            self.addNewEntity = addNewEntity
            addNewEntityList?.moodDescribeArray.remove(at: itemIndex)
            addNewEntityList?.activitySelectionArray.remove(at: itemIndex)
            addNewEntityList?.moodDateArray.remove(at: itemIndex)
            addNewEntityList?.moodEmojiArray.remove(at: itemIndex)
            addNewEntityList?.notesTextArray.remove(at: itemIndex)
            addNewEntityList?.idArray.remove(at: itemIndex)
        }
    }
}
