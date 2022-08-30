//
//  JournalPageRouter.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.08.2022.
//

import UIKit

protocol JournalPageRouterProtocol {
    func routeToAnalizePage()
}

class JournalPageRouter: JournalPageRouterProtocol {
    
    weak var view: UIViewController?
    
    class func createModule() -> JournalPageViewController {
        let view = JournalPageViewController()
        let interactor = JournalPageInteractor()
        let presenter = JournalPagePresenter()
        let router = JournalPageRouter()
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.view = view
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        return view
    }
    
    func routeToAnalizePage() {
        view?.dismiss(animated: true)
    }
}
