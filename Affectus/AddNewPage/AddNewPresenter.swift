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
    func notifyShowButtonTapped(_ localIndex: Int, _ selectedId: UUID)
}

protocol AddNewInteractorOutputProtocol: AnyObject {
    func didSaveDataWithSuccess()
    func didSaveDataWithError()
    func notifyDidFetchData(_ entity: AddNewEntityList, _ localIndex: Int, _ selectedId: UUID)
}

class AddNewPresenter: AddNewPresenterProtocol {
    weak var view: AddNewViewControllerProtocol?
    var interactor: AddNewInteractorProtocol?
    var router: AddNewRouterProtocol?
    
    func notifySaveButtonTapped(_ id: UUID, _ selectedDate: Date, _ givenText: String, _ selectedEmoji: Int, _ selectedEmotions: String, _ selectedActivies: String) {
        interactor?.saveToCoreData(id, selectedDate, givenText, selectedEmoji, selectedEmotions, selectedActivies)
    }
    
    func notifyShowButtonTapped(_ localIndex: Int, _ selectedId: UUID) {
        interactor?.fetchCoreData(localIndex, selectedId)
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
    
    func notifyDidFetchData(_ entity: AddNewEntityList, _ localIndex: Int, _ selectedId: UUID) {
        setAddNewPageData(entity, localIndex)
    }
    
    func setAddNewPageData(_ entities: AddNewEntityList, _ localIndex: Int) {
        view?.loadCoreData(noteText: entities.notesTextArray[localIndex],
                           moodEmoji: entities.moodEmojiArray[localIndex],
                           moodDescribe: entities.moodDescribeArray[localIndex],
                           moodActivity: entities.activitySelectionArray[localIndex],
                           moodDate: entities.moodDateArray[localIndex],
                           id: entities.idArray[localIndex])
    }
    
}
