//
//  AnalizePresenter.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 28.07.2022.
//

import Foundation

protocol AnalizePresenterProtocol: AnyObject {
    func notifyViewDidload()
}

protocol AnalizeInteractorOutputProtocol: AnyObject {
    func didFetchCoreData(_ listData: AddNewEntityList)
}

class AnalizePresenter: AnalizePresenterProtocol {
    weak var view: AnalizeViewControllerProtocol?
    var interactor: AnalizeInteractorProtocol?
    var router: AnalizeRouterProtocol?
    
    func notifyViewDidload() {
        interactor?.fetchCoreData()
    }
    
}

extension AnalizePresenter: AnalizeInteractorOutputProtocol {
    func didFetchCoreData(_ listData: AddNewEntityList) {
        view?.loadCoreData(listData)
    }
}
