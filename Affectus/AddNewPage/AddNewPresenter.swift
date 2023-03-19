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
    func notifyEditSaveButtonTapped(_ selectedId: UUID)
    func isTodayDateGiven(selectedDate: Date) -> Bool
}

protocol AddNewInteractorOutputProtocol: AnyObject {
    func didSaveDataWithSuccess()
    func didSaveDataWithError()
    
    func deleteOnSuccess()
    func deleteOnError()
}

class AddNewPresenter: AddNewPresenterProtocol {
    weak var view: AddNewViewControllerProtocol?
    var interactor: AddNewInteractorProtocol?
    var router: AddNewRouterProtocol?
    
    var unsortedListData = [AddNewEntity]()
    
    func notifySaveButtonTapped(_ id: UUID, _ selectedDate: Date, _ givenText: String, _ selectedEmoji: Int, _ selectedEmotions: String, _ selectedActivies: String) {
        interactor?.saveToCoreData(id, selectedDate, givenText, selectedEmoji, selectedEmotions, selectedActivies)
    }
    
    func notifyShowButtonTapped(_ showUUID: UUID) {
        interactor?.fetchCoreData(completion: { listData in
            unsortedListData = listData
            for listItem in listData where showUUID == listItem.id {
                setAddNewPageData(listItem)
            }
        })
    }
    
    func notifyEditSaveButtonTapped(_ selectedId: UUID) {
        for (index, listItem) in unsortedListData.enumerated() where selectedId == listItem.id {
            interactor?.didDeleteItem(selectedId, index)
        }
    }
    
    private func fetchCoreDatas(completion: (_ entity: [AddNewEntity]) -> ()) {
        CoreDataManager.shared.loadData { addNewEntityListSample in
            completion(addNewEntityListSample.sampleEntity)
        }
    }
    
    func isTodayDateGiven(selectedDate: Date) -> Bool {
        var newDateStrArr = [String]()
        var returnValue: Bool?
        fetchCoreDatas { entity in
            for date in entity {
                newDateStrArr.append(date.moodDate?.dateToString("yyyy-MM-dd") ?? "")
            }
            returnValue = newDateStrArr.contains(selectedDate.dateToString("yyyy-MM-dd"))
        }
        
        return returnValue ?? false
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
    
    func deleteOnSuccess() {
        view?.deleteItemWithSuccess()
    }
    
    func deleteOnError() {
        view?.deleteItemWithError()
    }
    
}
