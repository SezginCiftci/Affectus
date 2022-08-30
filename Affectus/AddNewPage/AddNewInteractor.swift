//
//  AddNewInteractor.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import Foundation

protocol AddNewInteractorProtocol {
    func saveToCoreData(_ id: UUID, _ selectedDate: Date, _ givenText: String, _ selectedEmoji: Int, _ selectedEmotions: String, _ selectedActivies: String)
}

class AddNewInteractor: AddNewInteractorProtocol {
    weak var presenter: AddNewInteractorOutputProtocol?
    
    func saveToCoreData(_ id: UUID, _ selectedDate: Date, _ givenText: String, _ selectedEmoji: Int, _ selectedEmotions: String, _ selectedActivies: String) {
        CoreDataManager.shared.saveData(id: id, moodDate: selectedDate, notesText: givenText, moodEmoji: selectedEmoji, moodDescribe: selectedEmotions, activitySelection: selectedActivies)
    }
}
