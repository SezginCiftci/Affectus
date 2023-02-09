//
//  AnalizeInteractor.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 28.07.2022.
//

import Foundation

protocol AnalizeInteractorProtocol {
    func fetchCoreData()
    //func fetchDataForCalender(_ completion: AddNewEntityList)
}

class AnalizeInteractor: AnalizeInteractorProtocol {
    
    weak var presenter: AnalizeInteractorOutputProtocol?
    var listData: AddNewEntityList?
    var sampleList: AddNewEntityListSample?
    
    func fetchCoreData() {
        CoreDataManager.shared.loadData { addNewEntityListSample in
            self.sampleList = addNewEntityListSample
            guard let sampleList = sampleList else {
                return
            }
            presenter?.didFetchCoreData(sampleList)
        }
    }
    
}
