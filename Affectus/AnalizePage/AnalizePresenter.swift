//
//  AnalizePresenter.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 28.07.2022.
//

import Foundation

protocol AnalizePresenterProtocol: AnyObject {
    func notifyBackButtonTapped()
    func notifyViewDidload()
    func notifyJournalButtonTapped()
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
    
    func notifyBackButtonTapped() {
        router?.routeToMainPage()
    }
    
    func notifyJournalButtonTapped() {
        router?.routeToJournalPage()
    }
}

extension AnalizePresenter: AnalizeInteractorOutputProtocol {
    func didFetchCoreData(_ listData: AddNewEntityList) {
        view?.loadCoreData(listData)
    }
}
