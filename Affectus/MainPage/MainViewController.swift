//
//  MainViewController.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func loadCoreData(_ listData: AddNewEntityList)
    func deleteItemWithSuccess()
    func deleteItemWithError()
}

class MainViewController: UIViewController, MainViewControllerProtocol, EditOrDeleteViewDelegate {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var presenter: MainPresenterProtocol?
    
    var editView: EditOrDeletePopupView = {
        let view = EditOrDeletePopupView(frame: .zero)
        return view
    }()
    
    var listData: AddNewEntityList?
    var addNewEntity: AddNewEntity?
    var localIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.notifyViewDidLoad()
        configureUI()
        saveUserPassedOnboarding()
        sendLocalNotification()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didNewDataFetched(_ :)),
                                               name: .didSavedNewData,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.notifyViewWillAppear()
        configureTabbar()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didNewDataFetched(_ :)),
                                               name: .didSavedNewData,
                                               object: nil)
    }
    
    func saveUserPassedOnboarding() {
        UserDefaults.standard.set(true, forKey: "UserPassedOnboarding")
    }
    
    @objc func didNewDataFetched(_ notification: Notification) {
        CoreDataManager.shared.loadData {  addNewEntityList in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.listData = addNewEntityList
                self.mainCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.notifyViewWillDisappear()
    }
    
    func deleteItemWithSuccess() {
        animateWithImage("checked")
    }
    
    func deleteItemWithError() {
        let okButton = UIAlertAction(title: "OK", style: .cancel)
        showAlertView(title: "Error!",
                      message: "Something went wrong, try again later.",
                      alertActions: [okButton])
    }
    
    private func configureTabbar() {
        tabBarController?.tabBar.isUserInteractionEnabled = true
        tabBarController?.tabBar.isHidden = false
    }
    
    func loadCoreData(_ listData: AddNewEntityList) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.listData = listData
            self.mainCollectionView.reloadData()
        }
    }
    
    func sendLocalNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .sound, .alert]) { granted, error in
            if error == nil {
                print("User permission is granted : \(granted)")
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Affectus"
        content.body = "It's time to save your mood!"
        
        var dateComponenet = DateComponents()
        dateComponenet.hour = 10
        dateComponenet.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponenet, repeats: true)
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        center.add(request) { error in
            
        }
    }
    
    func showButtonTapped(_ selectedId: UUID) {
        guard let localIndex = localIndex else { return }
        presenter?.notifyShowButtonTapped(selectedId, localIndex)
        editView.removeFromSuperview()
        tabBarController?.tabBar.isUserInteractionEnabled = true
        tabBarController?.tabBar.isHidden = false
    }
    
    func deleteButtonTapped(_ selectedId: UUID) {
        guard let localIndex = localIndex else { return }
        presenter?.notifyDeleteButtonTapped(selectedId, localIndex)
        
        self.editView.removeFromSuperview()
        self.mainCollectionView.reloadData()
        tabBarController?.tabBar.isUserInteractionEnabled = true
        tabBarController?.tabBar.isHidden = false
        presenter?.notifyViewDidLoad()
    }
    
    func dismissView() {
        editView.removeFromSuperview()
        tabBarController?.tabBar.isUserInteractionEnabled = true
        tabBarController?.tabBar.isHidden = false
    }
    
    func configureUI() {
        configureCollectionView()
        editView.editOrDeleteDelegate = self
        tabBarController?.tabBar.isUserInteractionEnabled = true
        tabBarController?.tabBar.isHidden = false
    }
    
    func configureCollectionView() {
        mainCollectionView.register(UINib(nibName: "MainCell", bundle: nil),
                                forCellWithReuseIdentifier: "MainCell")
        mainCollectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
    }
    
    @IBAction func infoButtonAct(_ sender: UIButton) {
        let infoVC = InfoViewController(.homeInfo)
        infoVC.modalTransitionStyle = .crossDissolve
        infoVC.modalPresentationStyle = .overCurrentContext
        present(infoVC, animated: true)
    }
    
}
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 50, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData?.idArray.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as! MainCell
        
        cell.titleLabel.text = listData?.moodDescribeArray[indexPath.row]
        cell.descriptionLabel.text = listData?.moodDateArray[indexPath.row].dateToString("d MMM yyyy HH:mm")
        cell.cellImageview.image = cell.generateCellImage(listData?.moodEmojiArray[indexPath.row] ?? 0)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.addSubview(editView)
        editView.frame = CGRect(x: 0, y: 0,
                                  width: view.frame.width,
                                  height: view.frame.height)
        editView.selectedId = listData?.idArray[indexPath.row]
        localIndex = indexPath.row
        tabBarController?.tabBar.isUserInteractionEnabled = false
        tabBarController?.tabBar.isHidden = true
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let headerReusableView = (collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as? HeaderCollectionReusableView) {
            headerReusableView.updateHeaderView(headerReusableView.headerImage, headerReusableView.headerTitle)
            return headerReusableView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: (view.frame.width), height: 200)
    }
                               
}

