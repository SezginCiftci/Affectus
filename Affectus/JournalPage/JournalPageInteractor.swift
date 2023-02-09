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
    var sampleList: AddNewEntityListSample?
    
    func didFetchCoreData() {
        CoreDataManager.shared.loadData { addNewEntityListSample in
            self.sampleList = addNewEntityListSample
            guard let sampleList = sampleList else {
                return
            }
            presenter?.notifyDidFetchCoreData(sampleList)
        }
    }
}
