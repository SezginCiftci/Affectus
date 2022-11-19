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
    func notifyViewWillDisappear()
    
    func notifyAnalizeTapped()
    func notifyShowButtonTapped(_ selectedId: UUID, _ localIndex: Int)
    func notifyDeleteButtonTapped(_ selectedId: UUID, _ itemIndex: Int)
}

protocol MainInteractorOutputProtocol: AnyObject {
    func didFetchCoreData(_ listData: AddNewEntityList)
    func notifyDidFetchData(_ listData: AddNewEntityList)
    func deleteOnSuccess()
    func deleteOnError()
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
    
    func notifyViewWillDisappear() {
        interactor?.removeNotificationObservers()
    }
    
    func notifyAnalizeTapped() {
        router?.routeToAnalizeVC()
    }
    
    func notifyShowButtonTapped(_ selectedId: UUID, _ localIndex: Int) {
        router?.routeToAddNewVC(selectedId, localIndex)
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
    
    func deleteOnSuccess() {
        view?.deleteItemWithSuccess()
    }
    
    func deleteOnError() {
        view?.deleteItemWithError()
    }
    
}
