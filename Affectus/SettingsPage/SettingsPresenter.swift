//
//  SettingsPresenter.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import Foundation

protocol SettingsPresenterProtocol: AnyObject {
    func notifyGiveStarCellTapped()
    func notifyGiveFeedbackCellTapped(_ settingsVCSelf: SettingsViewController)
    func notifyDisableCellTapped()
}

protocol SettingsInteractorOutputProtocol: AnyObject {
    
}

class SettingsPresenter: SettingsPresenterProtocol {
    
    weak var view: SettingsViewControllerProtocol?
    var interactor: SettingsInteractorProtocol?
    var router: SettingsRouterProtocol?
    
    func notifyGiveStarCellTapped() {
        interactor?.didGiveStar()
    }
    
    func notifyGiveFeedbackCellTapped(_ settingsVCSelf: SettingsViewController) {
        router?.routeToEmailCoposerVC(settingsVCSelf)
    }
    
    func notifyDisableCellTapped() {
        interactor?.didDisableAffectus()
    }
}

extension SettingsPresenter: SettingsInteractorOutputProtocol {
    
}
