//
//  MainRouter.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import UIKit

protocol MainRouterProtocol {
    func routeToAnalizeVC()
    func routeToAddNewVC(_ selectedId: UUID)
}

class MainRouter: MainRouterProtocol {
    
    weak var view: UIViewController?
    
    class func createModule() -> MainViewController {
        let view = MainViewController()
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.view = view
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        return view
    }
    
    func routeToAnalizeVC() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let analizeVC = AnalizeRouter.createModule()
            analizeVC.modalTransitionStyle = .crossDissolve
            analizeVC.modalPresentationStyle = .fullScreen
            self.view?.present(analizeVC, animated: true)
        }
    }
    
    func routeToAddNewVC(_ selectedId: UUID) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let addNew = AddNewRouter.createModule()
            addNew.isShowButtonTapped = true
            addNew.showUUID = selectedId
            addNew.modalPresentationStyle = .fullScreen
            self.view?.present(addNew, animated: true)
        }
    }
}
