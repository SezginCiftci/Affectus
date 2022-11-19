//
//  SplashViewController.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 16.11.2022.
//

import UIKit

class SplashScreenViewController: UIViewController {

    fileprivate var imageView = UIImageView()
    fileprivate var darkView = UIView()
    fileprivate var pageControl = UIPageControl()
    fileprivate var titleLabel = UILabel()
    fileprivate var contentLabel = UILabel()
    fileprivate var pageView = UIView()
    
    fileprivate var items = [
        SplashScreenItem(title: "Travel the World", content: "During the travel, save your stopping places as well as your destinations!", backgroundImage: UIImage(named: "onboarding-1")),
        SplashScreenItem(title: "Use Map Like Old Travelers", content: "Mapping is a kind of old school saving process, enjoy that!", backgroundImage: UIImage(named: "onboarding-2")),
        SplashScreenItem(title: "Save Your Comments However You Like", content: "You are able to save your comments as well like travel book!", backgroundImage: UIImage(named: "onboarding-3"))
    ]
    
    fileprivate var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI(currentPage)
        setGesture()
        imageAnimation(currentPage)
        setImages()
    }
    
    fileprivate func setImages() {
        darkView.backgroundColor = UIColor.init(white: 0.1, alpha: 0.5)
    }
    
    fileprivate func imageAnimation(_ index: Int) {
        let image =  items[index].backgroundImage
        
        UIView.transition(with: imageView, duration: 1, options: .transitionCrossDissolve) {
        self.imageView.image = image
        }
    }
    
    fileprivate func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc fileprivate func handleGesture() {
     
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn) {
            
            self.titleLabel.alpha = 0.8
            self.titleLabel.transform = CGAffineTransform(translationX: -30, y: 0)
        
        } completion: { _ in
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn) {
                self.titleLabel.alpha = 0
                self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -550)
            }
        }
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn) {
            
            self.contentLabel.alpha = 0.8
            self.contentLabel.transform = CGAffineTransform(translationX: -30, y: 0)
            
        } completion: { _ in
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn) {
                
                self.contentLabel.alpha = 0
                self.contentLabel.transform = CGAffineTransform(translationX: 0, y: -550)
                
            } completion: { _ in
                
                if self.currentPage < (self.items.count - 1) {
                    self.imageAnimation(self.currentPage + 1)
                }
                
                self.currentPage += 1
                self.titleLabel.alpha = 1
                self.contentLabel.alpha = 1
                self.titleLabel.transform = .identity
                self.contentLabel.transform = .identity
                
                if self.isIndexDone {
                    self.goMainVC()
                } else {
                    self.setUI(self.currentPage)
                }
            }
        }
    }
    
    fileprivate func goMainVC() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut) {
            self.view.alpha = 0
            self.titleLabel.text = ""
            self.contentLabel.text = ""
        } completion: { _ in
            self.view.isHidden = true
            let mainVC = MainTabbarViewController()
            mainVC.modalTransitionStyle = .crossDissolve
            mainVC.modalPresentationStyle = .fullScreen
            self.present(mainVC, animated: true)
        }
    }
    
    fileprivate var isIndexDone: Bool {
        return self.currentPage == self.items.count
    }
    
    fileprivate func setUI(_ index: Int) {
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.contentMode = .scaleAspectFill
        
        view.addSubview(darkView)
        darkView.translatesAutoresizingMaskIntoConstraints = false
        darkView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        darkView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        darkView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        darkView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        darkView.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerXAnchor.constraint(equalTo: darkView.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: darkView.bottomAnchor, constant: -25).isActive = true
        pageControl.numberOfPages = items.count
        pageControl.currentPage = index
        
        darkView.addSubview(pageView)
        pageView.translatesAutoresizingMaskIntoConstraints = false
        pageView.topAnchor.constraint(equalTo: darkView.topAnchor).isActive = true
        pageView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -30).isActive = true
        pageView.leadingAnchor.constraint(equalTo: darkView.leadingAnchor).isActive = true
        pageView.trailingAnchor.constraint(equalTo: darkView.trailingAnchor).isActive = true
        pageView.backgroundColor = .clear
        
        pageView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: pageView.leadingAnchor, constant: 50).isActive = true
        titleLabel.topAnchor.constraint(equalTo: pageView.topAnchor, constant: 300).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: pageView.trailingAnchor, constant: -30).isActive = true
        titleLabel.contentMode = .scaleToFill
        titleLabel.sizeToFit()
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .white
        titleLabel.text = items[index].title
        
        pageView.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -20).isActive = true
        contentLabel.leadingAnchor.constraint(equalTo: pageView.leadingAnchor, constant: 50).isActive = true
        contentLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: pageView.trailingAnchor, constant: -30).isActive = true
        contentLabel.contentMode = .scaleToFill
        contentLabel.sizeToFit()
        contentLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        contentLabel.numberOfLines = 4
        contentLabel.backgroundColor = .clear
        contentLabel.textColor = .white
        contentLabel.text = items[index].content
    }
}
