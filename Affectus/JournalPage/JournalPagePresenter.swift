//
//  JournalPagePresenter.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.08.2022.
//

import Foundation

protocol JournalPagePresenterProtocol: AnyObject {
    func notifyViewDidLoad()
    func notifyBackButtonTapped()
}

protocol JournalPageInteractorOutputProtocol: AnyObject  {
    func notifyDidFetchCoreData(_ listData: AddNewEntityList)
}

class JournalPagePresenter: JournalPagePresenterProtocol {
    
    weak var view: JournalPageViewControllerProtocol?
    var interactor: JournalPageInteractorProtocol?
    var router: JournalPageRouterProtocol?
    
    func notifyViewDidLoad() {
        interactor?.didFetchCoreData()
    }
    
    func notifyBackButtonTapped() {
        router?.routeToAnalizePage()
    }
}

extension JournalPagePresenter: JournalPageInteractorOutputProtocol {
    func notifyDidFetchCoreData(_ listData: AddNewEntityList) {
        view?.loadCoreData(listData)
    }
}
