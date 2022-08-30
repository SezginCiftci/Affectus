//
//  JournalPageInteractor.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.08.2022.
//

import Foundation

protocol JournalPageInteractorProtocol {
    func didFetchCoreData()
}

class JournalPageInteractor: JournalPageInteractorProtocol {
    weak var presenter: JournalPageInteractorOutputProtocol?
    var listData: AddNewEntityList?
    
    func didFetchCoreData() {
        CoreDataManager.shared.loadData { addNewEntityList in
            self.listData = addNewEntityList
            guard let listData = listData else {
                return
            }
            presenter?.notifyDidFetchCoreData(listData)
        }
    }
}
