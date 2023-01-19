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
    func notifyPaymentButtonTappe()
}

protocol SettingsInteractorOutputProtocol: AnyObject {
    func deleteOnSuccess()
    func deleteOnError()
}

class SettingsPresenter: SettingsPresenterProtocol {
    
    weak var view: SettingsViewControllerProtocol?
    var interactor: SettingsInteractorProtocol?
    var router: SettingsRouterProtocol?
    
    func notifyGiveStarCellTapped() {
        router?.routeToAppStore()
    }
    
    func notifyGiveFeedbackCellTapped(_ settingsVCSelf: SettingsViewController) {
        router?.routeToEmailCoposerVC(settingsVCSelf)
    }
    
    func notifyDisableCellTapped() {
        interactor?.didDisableAffectus()
    }
    
    func notifyPaymentButtonTappe() {
        interactor?.didPaymentTapped()
    }
}

extension SettingsPresenter: SettingsInteractorOutputProtocol {
    
    func deleteOnSuccess() {
        view?.deletedAllSuccess()
    }
    
    func deleteOnError() {
        view?.deletedAllError()
    }
}
