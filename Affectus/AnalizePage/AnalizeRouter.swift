//
//  AnalizeRouter.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 28.07.2022.
//

import UIKit

protocol AnalizeRouterProtocol {
    func routeToMainPage()
    func routeToJournalPage()
}

class AnalizeRouter: AnalizeRouterProtocol {
    
    weak var view: UIViewController?
    
    class func createModule() -> AnalizeViewController {
        let view = AnalizeViewController()
        let interactor = AnalizeInteractor()
        let presenter = AnalizePresenter()
        let router = AnalizeRouter()
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.view = view
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        return view
    }
    
    func routeToMainPage() {
        view?.dismiss(animated: true)
    }
    
    func routeToJournalPage() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let journalPage = JournalPageRouter.createModule()
            journalPage.modalPresentationStyle = .fullScreen
            journalPage.modalTransitionStyle = .crossDissolve
            self.view?.present(journalPage, animated: true)
        }
    }
}
