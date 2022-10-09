//
//  SettingsInteractor.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import Foundation

protocol SettingsInteractorProtocol {
    func didGiveStar()
    func didDisableAffectus()
}

class SettingsInteractor: SettingsInteractorProtocol {
    weak var presenter: SettingsInteractorOutputProtocol?
    
    func didGiveStar() {
        
    }
    
    func didDisableAffectus() {

    }
}
