//
//  AddNewRouter.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import UIKit

protocol AddNewRouterProtocol {
    func routeToMainPage()
    func routeToDatePage(_ addVCSelf: AddNewViewController)
    func routeToPickEmotionView(_ selectedEntity: [String], _ addVCSelf: AddNewViewController)
}

class AddNewRouter: AddNewRouterProtocol {
    
    weak var view: UIViewController?
    
    class func createModule() -> AddNewViewController {
        let view = AddNewViewController()
        let interactor = AddNewInteractor()
        let presenter = AddNewPresenter()
        let router = AddNewRouter()
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.view = view
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        return view
    }
    
    func routeToDatePage(_ addVCSelf: AddNewViewController) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let dateVC = DatePickViewController()
            dateVC.dateDelegate = addVCSelf
            self.view?.present(dateVC, animated: true)
        }
    }
    
    func routeToPickEmotionView(_ selectedEntity: [String], _ addVCSelf: AddNewViewController) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let pickEmotionVC = PickEmotionViewController()
            pickEmotionVC.pickEmotionDelegate = addVCSelf
            pickEmotionVC.pickEmotionArray = selectedEntity
            pickEmotionVC.modalTransitionStyle = .crossDissolve
            pickEmotionVC.modalPresentationStyle = .overCurrentContext
            self.view?.present(pickEmotionVC, animated: true)
        }
    }
    
    func routeToMainPage() {
        view?.dismiss(animated: true)
    }
    
}
