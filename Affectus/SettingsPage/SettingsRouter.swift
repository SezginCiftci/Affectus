//
//  SettingsRouter.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import UIKit
import MessageUI

protocol SettingsRouterProtocol {
    func routeToEmailCoposerVC(_ settingsVCSelf: SettingsViewController)
    func routeToAppStore() 
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

    func routeToEmailCoposerVC(_ settingsVCSelf: SettingsViewController) {
        guard MFMailComposeViewController.canSendMail() else {
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            self.view?.showAlertView(title: "Error!", message: "Something went wrong. Check your conneciton just in case.", alertActions: [okAction])
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = settingsVCSelf
        composer.setToRecipients(["sezgin0776@gmail.com"])
        composer.setSubject("Affectus Feedback")
        self.view?.present(composer, animated: true)
    }
    
    func routeToAppStore() {
        //TODO: - Routing AppStore
    }
}
