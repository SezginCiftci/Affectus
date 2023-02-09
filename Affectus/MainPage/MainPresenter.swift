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
    func notifyShowButtonTapped(_ selectedId: UUID)
    func notifyDeleteButtonTapped(_ selectedId: UUID)
}

protocol MainInteractorOutputProtocol: AnyObject {
    func didFetchCoreData(_ listData: AddNewEntityListSample)
    func notifyDidFetchData(_ slistData: AddNewEntityListSample)

    func deleteOnSuccess()
    func deleteOnError()
}

class MainPresenter: MainPresenterProtocol {
    
    weak var view: MainViewControllerProtocol?
    var interactor: MainInteractorProtocol?
    var router: MainRouterProtocol?
    
    var unsortedListData = [AddNewEntity]()
    
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
    
    func notifyShowButtonTapped(_ selectedId: UUID) {
        router?.routeToAddNewVC(selectedId)
    }
    
    func notifyDeleteButtonTapped(_ selectedId: UUID) {
        for (index, listItem) in unsortedListData.enumerated() where selectedId == listItem.id {
            interactor?.didDeleteItem(selectedId, index)
        }
    }
    
    
}

extension MainPresenter: MainInteractorOutputProtocol {
    func notifyDidFetchData(_ slistData: AddNewEntityListSample) {
        unsortedListData = slistData.sampleEntity
        view?.loadCoreData(slistData)
    }
    
    func didFetchCoreData(_ listData: AddNewEntityListSample) {
        view?.loadCoreData(listData) //
    }
   
    func deleteOnSuccess() {
        view?.deleteItemWithSuccess()
    }
    
    func deleteOnError() {
        view?.deleteItemWithError()
    }
    
}
