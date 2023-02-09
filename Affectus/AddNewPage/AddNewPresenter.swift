//
//  AddNewPresenter.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import Foundation

protocol AddNewPresenterProtocol: AnyObject {
    func notifyBackButtonTapped()
    func notifySaveButtonTapped(_ id: UUID, _ selectedDate: Date, _ givenText: String, _ selectedEmoji: Int, _ selectedEmotions: String, _ selectedActivies: String)
    func notifyPickEmotionAndActivityButtonTapped(_ selectedEntity: [String], _ self: AddNewViewController)
    func notifyDateButtonTapped(_ self: AddNewViewController)
    func notifyShowButtonTapped(_ showUUID: UUID)
}

protocol AddNewInteractorOutputProtocol: AnyObject {
    func didSaveDataWithSuccess()
    func didSaveDataWithError()
}

class AddNewPresenter: AddNewPresenterProtocol {
    weak var view: AddNewViewControllerProtocol?
    var interactor: AddNewInteractorProtocol?
    var router: AddNewRouterProtocol?
    
    func notifySaveButtonTapped(_ id: UUID, _ selectedDate: Date, _ givenText: String, _ selectedEmoji: Int, _ selectedEmotions: String, _ selectedActivies: String) {
        interactor?.saveToCoreData(id, selectedDate, givenText, selectedEmoji, selectedEmotions, selectedActivies)
    }
    
    func notifyShowButtonTapped(_ showUUID: UUID) {
        interactor?.fetchCoreData(completion: { listData in
            for listItem in listData where showUUID == listItem.id {
                setAddNewPageData(listItem)
            }
        })
    }
    
    func notifyDateButtonTapped(_ self: AddNewViewController) {
        router?.routeToDatePage(self)
    }
    
    func notifyBackButtonTapped() {
        router?.routeToMainPage()
    }
    
    func notifyPickEmotionAndActivityButtonTapped(_ selectedEntity: [String], _ self: AddNewViewController) {
        router?.routeToPickEmotionView(selectedEntity, self)
    }
    
}

extension AddNewPresenter: AddNewInteractorOutputProtocol {
    
    func didSaveDataWithSuccess() {
        view?.dismissViewController()
    }
    
    func didSaveDataWithError() {
        view?.saveDataFailed()
    }
    
    func setAddNewPageData(_ entities: AddNewEntity) {
        view?.loadCoreData(noteText: entities.notesText ?? "", moodEmoji: entities.moodEmoji ?? 0, moodDescribe: entities.moodDescribe ?? "", moodActivity: entities.activitySelection ?? "", moodDate: entities.moodDate ?? .now, id: entities.id ?? UUID())
    }
    
}
