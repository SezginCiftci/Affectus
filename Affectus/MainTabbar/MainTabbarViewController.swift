//
//  MainTabbarViewController.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import UIKit

class MainTabbarViewController: UITabBarController {
    
    var plusButton = UIButton()
    var pulse: PulseAnimation?
    private var addNewEntityList: AddNewEntityList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPlusButton()
        fetchCoreDatas()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        configureTabbar()
    }
    
    private func fetchCoreDatas() {
        CoreDataManager.shared.loadData { [weak self] addNewEntityList in
            guard let self = self else { return }
            self.addNewEntityList = addNewEntityList
        }
    }
    
    private func isTodayDateGiven() -> Bool {
        var newDateStrArr = [String]()
        let today = Date()
        if let dateArr = addNewEntityList?.moodDateArray {
            for date in dateArr {
                newDateStrArr.append(date.dateToString("yyyy-MM-dd"))
            }
            return newDateStrArr.contains(today.dateToString("yyyy-MM-dd"))
        }
        return false
    }
    
    private func configureTabbar() {
        let homeVC = MainRouter.createModule()
        let settingsVC = SettingsRouter.createModule()
        let addVC = AddNewRouter.createModule()
        let analizeVC = AnalizeRouter.createModule()
        let journalVC = JournalPageRouter.createModule()
        analizeVC.tabBarItem.image = UIImage(systemName: "chart.xyaxis.line")
        journalVC.tabBarItem.image = UIImage(systemName: "text.book.closed.fill")
        homeVC.tabBarItem.image = UIImage(systemName: "house.fill")
        settingsVC.tabBarItem.image = UIImage(systemName: "gearshape.fill")
        analizeVC.tabBarItem.title = "Analize"
        journalVC.tabBarItem.title = "Journal"
        homeVC.tabBarItem.title = "Home"
        settingsVC.tabBarItem.title = "Settings"
        setViewControllers([homeVC, analizeVC, addVC, journalVC, settingsVC], animated: false)
        modalPresentationStyle = .fullScreen
        tabBar.tintColor = .black
        tabBar.barTintColor = .systemPurple
//        tabBar.selectedItem?.badgeValue = "New"
        tabBar.unselectedItemTintColor = .secondaryLabel
        tabBar.backgroundColor = UIColor(named: "tabbarColor")
    }
    
    public func setupPlusButton() {
        plusButton = UIButton(frame: CGRect(x: (view.bounds.width / 2) - 25,
                                            y: -10,
                                            width: view.bounds.width/7,
                                            height: view.bounds.width/7))
        plusButton.setBackgroundImage(UIImage(named: "plus-2.png"), for: .normal)
        plusButton.layer.shadowColor = UIColor.black.cgColor
        plusButton.layer.shadowOpacity = 0.3
        plusButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        plusButton.layer.cornerRadius = plusButton.frame.width / 2
        plusButton.clipsToBounds = true
        
        initPulseAnimation()
    }
    
    public func initPulseAnimation() {
        pulse = PulseAnimation(numberOfPulses: Float.infinity, radius: 100, position: plusButton.center)
        pulse?.animationDuration = 1.0
        pulse?.backgroundColor = UIColor.systemPurple.cgColor
        tabBar.layer.insertSublayer(pulse!, below: view.layer)
        plusButton.addTarget(self, action: #selector(handlePlusButton), for: .touchUpInside)
        tabBar.addSubview(plusButton)
        view.layoutIfNeeded()
    }
    
    @objc private func handlePlusButton() {
        if isTodayDateGiven() {
            showAlertView(title: "Error!", message: "You have already given your mood", alertActions: [])
        } else {
            let addVC = AddNewRouter.createModule()
            addVC.modalPresentationStyle = .fullScreen
            addVC.isShowButtonTapped = false
            present(addVC, animated: true)
        }
    }
}
