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
    var sampleEntityList: AddNewEntityListSample?
    var addNewEntity: AddNewEntity?
    
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didNewDataFetched),
                                               name: .didSavedNewData,
                                               object: nil)
    }
    
    func removeNotificationObservers()  {
        NotificationCenter.default.removeObserver(self,
                                                  name: .didSavedNewData,
                                                  object: nil)
    }
    
    @objc func didNewDataFetched() {
        CoreDataManager.shared.loadData { [weak self] addNewEntityListSample in
            guard let self = self else { return }
            self.sampleEntityList = addNewEntityListSample
            DispatchQueue.global().async {
                self.presenter?.notifyDidFetchData(addNewEntityListSample)
            }
        }
    }
    
    func fetchCoreDatas() {
        CoreDataManager.shared.loadData { [weak self] addNewEntityListSample in
            guard let self = self else { return }
            self.sampleEntityList = addNewEntityListSample
            DispatchQueue.global().async {
                self.presenter?.notifyDidFetchData(addNewEntityListSample)
            }
        }
    }
    
    func didDeleteItem(_ selectedId: UUID, _ itemIndex: Int) {
        fetchCoreDatas()
        CoreDataManager.shared.deleteItem(chosenId: selectedId) { addNewEntity in
            sampleEntityList?.sampleEntity.remove(at: itemIndex)
        } onSuccess: {
            self.presenter?.deleteOnSuccess()
        } onError: {
            self.presenter?.deleteOnError()
        }
    }
}
