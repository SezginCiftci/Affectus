//
//  MainPresenter.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func notifyViewWillAppear()
    func notifyViewDidLoad()
    func notifyViewDidDisappear()
    
    func notifyAnalizeTapped()
    func notifyEditButtonTapped()
    func notifyDeleteButtonTapped(_ selectedId: UUID, _ itemIndex: Int)
}

protocol MainInteractorOutputProtocol: AnyObject {
    func didFetchCoreData(_ listData: AddNewEntityList)
    func notifyDidFetchData(_ listData: AddNewEntityList)
}

class MainPresenter: MainPresenterProtocol {
    
    weak var view: MainViewControllerProtocol?
    var interactor: MainInteractorProtocol?
    var router: MainRouterProtocol?
    
//    var listData: AddNewEntityList?
    
    func notifyViewDidLoad() {
        interactor?.fetchCoreDatas()
        interactor?.addObservers()
    }
    
    func notifyViewWillAppear() {
        interactor?.addObservers()
    }
    
    func notifyViewDidDisappear() {
        interactor?.removeNotificationObservers()
    }
    
    func notifyAnalizeTapped() {
        router?.routeToAnalizeVC()
    }
    
    func notifyEditButtonTapped() {
        router?.routeToAddNewVC()
    }
    
    func notifyDeleteButtonTapped(_ selectedId: UUID, _ itemIndex: Int) {
        interactor?.didDeleteItem(selectedId, itemIndex)
    }
    
    
}

extension MainPresenter: MainInteractorOutputProtocol {
    
    func didFetchCoreData(_ listData: AddNewEntityList) {
        view?.loadCoreData(listData)
    }
    
    func notifyDidFetchData(_ listData: AddNewEntityList) {
        view?.loadCoreData(listData)
    }
}
