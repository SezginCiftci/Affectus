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
    
    func fetchCoreData() {
        CoreDataManager.shared.loadData { addNewEntityList in
            self.listData = addNewEntityList
            guard let listData = listData else {
                return
            }
            presenter?.didFetchCoreData(listData)
        }
    }
//    func fetchDataForCalender(_ completion: (_ listData: AddNewEntityList) -> ()) {
//        CoreDataManager.shared.loadData { addNewEntityList in
//            self.listData = addNewEntityList
//            guard let listData = listData else {
//                return
//            }
//            completion(listData)
//        }
//    }
}
