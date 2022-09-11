//
//  AnalizeRouter.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 28.07.2022.
//

import UIKit

protocol AnalizeRouterProtocol {
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
    
}
