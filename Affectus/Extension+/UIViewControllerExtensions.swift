//
//  Extention+UIViewController.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 14.08.2022.
//

import UIKit

extension UIViewController {
    
    func animateWithImage(_ imageName: String) {
        view.isUserInteractionEnabled = false
        let animatedView = UIView()
        view.addSubview(animatedView)
        animatedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animatedView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animatedView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animatedView.heightAnchor.constraint(equalToConstant: 100),
            animatedView.widthAnchor.constraint(equalToConstant: 100)
        ])
        animatedView.layer.cornerRadius = 20
        animatedView.clipsToBounds = true
        animatedView.backgroundColor = .secondarySystemBackground
        animatedView.alpha = 1
        animatedView.layer.opacity = 0.85
        let lockImageView = UIImageView()
        animatedView.addSubview(lockImageView)
        lockImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lockImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lockImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lockImageView.heightAnchor.constraint(equalToConstant: 50),
            lockImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
        lockImageView.image = UIImage(named: imageName)
        lockImageView.backgroundColor = .clear
        lockImageView.sizeToFit()
        
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .transitionCrossDissolve) {
            for _ in 0...1 {
                animatedView.alpha -= 0.5
            }
            self.loadViewIfNeeded()
        } completion: { _ in
            animatedView.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
            self.dismiss(animated: true)
        }
    }
    
    func showAlertView(title: String, message: String, style: UIAlertController.Style = .alert, alertActions: [UIAlertAction]) {
        var actions = alertActions
        if actions.isEmpty {
            actions.append(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            alert.addAction(action)
        }
        self.present(alert, animated: true)
    }
}
