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
}

protocol AddNewInteractorOutputProtocol: AnyObject {
    
}

class AddNewPresenter: AddNewPresenterProtocol {
    weak var view: AddNewViewControllerProtocol?
    var interactor: AddNewInteractorProtocol?
    var router: AddNewRouterProtocol?
    
    func notifySaveButtonTapped(_ id: UUID, _ selectedDate: Date, _ givenText: String, _ selectedEmoji: Int, _ selectedEmotions: String, _ selectedActivies: String) {
        interactor?.saveToCoreData(id, selectedDate, givenText, selectedEmoji, selectedEmotions, selectedActivies)
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
    
}
