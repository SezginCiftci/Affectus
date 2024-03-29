//
//  SettingsInteractor.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import UIKit

protocol SettingsInteractorProtocol {
    func didDisableAffectus()
    func didPaymentTapped()
}

class SettingsInteractor: SettingsInteractorProtocol {
    weak var presenter: SettingsInteractorOutputProtocol?
    var addNewEntityList: AddNewEntityList?
    
    func didDisableAffectus() {
        UserDefaults.standard.set(nil, forKey: "Avatar")
        UserDefaults.standard.set(false, forKey: "UserPassedOnboarding")
        removeAllLocaleNotifications()
        didDeleteItem(UUID())
    }
    
    func didDeleteItem(_ selectedId: UUID) {
        CoreDataManager.shared.deleteAllItems { addNewEntity in
            self.addNewEntityList = addNewEntity
            addNewEntityList?.moodDescribeArray.removeAll()
            addNewEntityList?.activitySelectionArray.removeAll()
            addNewEntityList?.moodDateArray.removeAll()
            addNewEntityList?.moodEmojiArray.removeAll()
            addNewEntityList?.notesTextArray.removeAll()
            addNewEntityList?.idArray.removeAll()
        } onSuccess: {
            self.presenter?.deleteOnSuccess()
        } onError: {
            self.presenter?.deleteOnError()
        }
        exit(0)
    }
    
    func removeAllLocaleNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func didPaymentTapped() {
        
    }
}
