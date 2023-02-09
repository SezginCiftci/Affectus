//
//  MainTabbarViewController.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import UIKit

class MainTabbarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var plusButton = UIButton()
    var pulse: PulseAnimation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPlusButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        configureTabbar()
    }
    
    private func fetchCoreDatas(completion: (_ addNewEntityList: AddNewEntityListSample) -> ()) {
        CoreDataManager.shared.loadData { addNewEntityListSample in
            completion(addNewEntityListSample)
        }
    }
    
    private func isTodayDateGiven() -> Bool {
        var returnValue: Bool?
        var newDateStrArr = [String]()
        let today = Date()
        fetchCoreDatas { addNewEntityList in
            for date in addNewEntityList.sampleEntity {
                newDateStrArr.append(date.moodDate?.dateToString("yyyy-MM-dd") ?? "")
            }
            returnValue = newDateStrArr.contains(today.dateToString("yyyy-MM-dd"))
        }
        return returnValue ?? false
    }
    
    private func configureTabbar() {
        self.delegate = self
        let homeVC = MainRouter.createModule()
        let settingsVC = SettingsRouter.createModule()
        let addVC = AddNewRouter.createModule() //boş bir view controller koyulup etkisiz hale getirilmeli
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
        viewControllers = [homeVC, analizeVC, addVC, journalVC, settingsVC]
        modalPresentationStyle = .fullScreen
        tabBar.tintColor = .black
        tabBar.barTintColor = .systemPurple
//        tabBar.selectedItem?.badgeValue = "New"
        tabBar.unselectedItemTintColor = .secondaryLabel
        tabBar.backgroundColor = UIColor(named: "tabbarColor")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let viewControllers = viewControllers else { return true }
        if viewController == viewControllers[2] {
            return false
        }
        return true
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
        pulse = PulseAnimation(numberOfPulses: 5, radius: 100, position: plusButton.center)
        pulse?.animationDuration = 1.0
        pulse?.backgroundColor = UIColor.systemPurple.cgColor
        tabBar.layer.insertSublayer(pulse!, below: view.layer)
        plusButton.addTarget(self, action: #selector(handlePlusButton), for: .touchUpInside)
        tabBar.addSubview(plusButton)
        view.layoutIfNeeded()
    }
    
    @objc private func handlePlusButton() {
        if isTodayDateGiven() {
            showAlertView(title: "Ooops!", message: "You have already given your mood", alertActions: [])
        } else {
            let addVC = AddNewRouter.createModule()
            addVC.modalPresentationStyle = .fullScreen
            addVC.isShowButtonTapped = false
            present(addVC, animated: true)
        }
    }
}
