//
//  SettingsRouter.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import UIKit

protocol SettingsRouterProtocol {
    
}

class SettingsRouter: SettingsRouterProtocol {
    
    weak var view: UIViewController?
    
    class func createModule() -> SettingsViewController {
        let view = SettingsViewController()
        let interactor = SettingsInteractor()
        let presenter = SettingsPresenter()
        let router = SettingsRouter()
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.view = view
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        return view
    }

}
