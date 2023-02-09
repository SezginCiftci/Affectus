//
//  MainViewController.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func loadCoreData(_ slistData: AddNewEntityListSample)
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
    
    private var unsortedListData: [AddNewEntity] = []
    private var sortedListData: [AddNewEntity] = []
    private var localIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.notifyViewDidLoad()
        configureUI()
        sendLocalNotification()
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(didNewDataFetched(_ :)),
//                                               name: .didSavedNewData,
//                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.notifyViewWillAppear()
        configureTabbar()
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(didNewDataFetched(_ :)),
//                                               name: .didSavedNewData,
//                                               object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.notifyViewWillDisappear()
    }
    
    func saveUserPassedOnboarding() {
        UserDefaults.standard.set(true, forKey: "UserPassedOnboarding")
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
    
    func loadCoreData(_ slistData: AddNewEntityListSample) {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.sortedListData = self.sortData(slistData)
            self.mainCollectionView.reloadData()
        }
    }
    
    func sortData(_ list: AddNewEntityListSample) -> [AddNewEntity] { //MARK: - ???? sort hala sorun
        let sortedlist = list.sampleEntity.sorted { $0.moodDate! > $1.moodDate! }
        return sortedlist
    }
    
    func sendLocalNotification() {
        if !UserDefaults.standard.bool(forKey: "UserPassedOnboarding") {
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
            
            saveUserPassedOnboarding()
        }
    }
    
    func showButtonTapped(_ selectedId: UUID) {
        presenter?.notifyShowButtonTapped(selectedId)
        editView.removeFromSuperview()
        tabBarController?.tabBar.isUserInteractionEnabled = true
        tabBarController?.tabBar.isHidden = false
    }
    
    func deleteButtonTapped(_ selectedId: UUID) {
        presenter?.notifyDeleteButtonTapped(selectedId)
        
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
        mainCollectionView.register(UINib(nibName: String(describing: MainCell.self), bundle: nil),
                                forCellWithReuseIdentifier: String(describing: MainCell.self))
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
        return sortedListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MainCell.self), for: indexPath) as! MainCell
        cell.titleLabel.text = sortedListData[indexPath.row].moodDescribe
        cell.descriptionLabel.text = sortedListData[indexPath.row].moodDate!.dateToString("d MMM yyyy HH:mm")
        cell.cellImageview.image = cell.generateCellImage((sortedListData[indexPath.row].moodEmoji)!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.addSubview(editView)
        editView.frame = CGRect(x: 0, y: 0,
                                  width: view.frame.width,
                                  height: view.frame.height)
        editView.selectedId = sortedListData[indexPath.row].id
        //localIndex = indexPath.row
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

