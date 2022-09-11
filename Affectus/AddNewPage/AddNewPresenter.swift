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
    func notifySaveButtonTappedWithEdit(_ id: UUID, _ selectedDate: Date, _ givenText: String, _ selectedEmoji: Int, _ selectedEmotions: String, _ selectedActivies: String, _ selectedId: UUID, _ localIndex: Int)
    func notifyPickEmotionAndActivityButtonTapped(_ selectedEntity: [String], _ self: AddNewViewController)
    func notifyDateButtonTapped(_ self: AddNewViewController)
    func notifyEditButtonTapped(_ selectedId: UUID, _ localIndex: Int)
}

protocol AddNewInteractorOutputProtocol: AnyObject {
    func didSaveDataWithSuccess()
    func didSaveDataWithError()
    func notifyEditableDataFetched(_ listData: AddNewEntityList, _ localIndex: Int)
}

class AddNewPresenter: AddNewPresenterProtocol {
    weak var view: AddNewViewControllerProtocol?
    var interactor: AddNewInteractorProtocol?
    var router: AddNewRouterProtocol?
    
    func notifySaveButtonTapped(_ id: UUID, _ selectedDate: Date, _ givenText: String, _ selectedEmoji: Int, _ selectedEmotions: String, _ selectedActivies: String) {
        interactor?.saveToCoreData(id, selectedDate, givenText, selectedEmoji, selectedEmotions, selectedActivies)
    }
    
    func notifySaveButtonTappedWithEdit(_ id: UUID, _ selectedDate: Date, _ givenText: String, _ selectedEmoji: Int, _ selectedEmotions: String, _ selectedActivies: String, _ selectedId: UUID, _ localIndex: Int) {
        interactor?.saveToCoreDataWithEdit(id, selectedDate, givenText, selectedEmoji, selectedEmotions, selectedActivies, selectedId, localIndex)
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
    
    func notifyEditButtonTapped(_ selectedId: UUID, _ localIndex: Int) {
        interactor?.fetchCoreData(selectedId, localIndex)
    }
    
}

extension AddNewPresenter: AddNewInteractorOutputProtocol {
    
    func didSaveDataWithSuccess() {
        view?.dismissViewController()
    }
    
    func didSaveDataWithError() {
        view?.saveDataFailed()
    }
    
    func notifyEditableDataFetched(_ listData: AddNewEntityList, _ localIndex: Int) {
        DispatchQueue.main.async {
            self.view?.loadDataWithEdition(listData.moodDateArray[localIndex],
                                           listData.notesTextArray[localIndex],
                                           listData.moodEmojiArray[localIndex],
                                           listData.moodDescribeArray[localIndex],
                                           listData.activitySelectionArray[localIndex])
        }
    }
}
