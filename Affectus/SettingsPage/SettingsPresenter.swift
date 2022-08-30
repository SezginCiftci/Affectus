//
//  SettingsPresenter.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import Foundation

protocol SettingsPresenterProtocol: AnyObject {
    
}

protocol SettingsInteractorOutputProtocol: AnyObject {
    
}

class SettingsPresenter: SettingsPresenterProtocol {
    
    weak var view: SettingsViewControllerProtocol?
    var interactor: SettingsInteractorProtocol?
    var router: SettingsRouterProtocol?
}

extension SettingsPresenter: SettingsInteractorOutputProtocol {
    
}
