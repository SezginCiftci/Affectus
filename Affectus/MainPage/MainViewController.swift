//
//  MainViewController.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func loadCoreData(_ listData: AddNewEntityList)
}

class MainViewController: UIViewController, MainViewControllerProtocol, EditOrDeleteViewDelegate {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var statisticImageView: UIImageView!
    
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didNewDataFetched(_ :)),
                                               name: NSNotification.Name("new"),
                                               object: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.notifyViewWillAppear()
        configureTabbar()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didNewDataFetched(_ :)),
                                               name: NSNotification.Name("new"),
                                               object: nil)
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
        presenter?.notifyViewDidDisappear()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        presenter?.notifyViewDidDisappear()
//    }
    
//    deinit {
//        presenter?.notifyViewDidDisappear()
//    }
    
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
    
    func editButtonTapped() {
        editView.removeFromSuperview()
        tabBarController?.tabBar.isUserInteractionEnabled = true
        tabBarController?.tabBar.isHidden = false
        presenter?.notifyEditButtonTapped()
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
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(statisticAct(_:)))
        statisticImageView.addGestureRecognizer(gestureRecognizer)
        statisticImageView.isUserInteractionEnabled = true
        tabBarController?.tabBar.isUserInteractionEnabled = true
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func statisticAct(_ sender: UITapGestureRecognizer) {
        presenter?.notifyAnalizeTapped()
    }
    
    func configureCollectionView() {
        mainCollectionView.register(UINib(nibName: "MainCell", bundle: nil),
                                forCellWithReuseIdentifier: "MainCell")
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
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
        cell.descriptionLabel.text = listData?.activitySelectionArray[indexPath.row]
        cell.cellImageview.image = cell.generateCellImage(listData?.moodEmojiArray[indexPath.row] ?? 0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.addSubview(editView)
        editView.frame = CGRect(x: 0, y: 0,
                                  width: view.frame.width,
                                  height: view.frame.height)
        print(indexPath.row)
        editView.selectedId = listData?.idArray[indexPath.row]
        localIndex = indexPath.row
        tabBarController?.tabBar.isUserInteractionEnabled = false
        tabBarController?.tabBar.isHidden = true
        
    }
    
}

