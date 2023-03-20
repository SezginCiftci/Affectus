//
//  JournalPageViewController.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.08.2022.
//

import UIKit

protocol JournalPageViewControllerProtocol: AnyObject {
    func loadCoreData(_ listData: AddNewEntityListSample)
}

class JournalPageViewController: UIViewController, JournalPageViewControllerProtocol {
    
    @IBOutlet weak var journalCollectionView: UICollectionView!
    var presenter: JournalPagePresenterProtocol?
    //var sampleList: AddNewEntityListSample?
    var sortedListData = [AddNewEntity]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        presenter?.notifyViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didNewDataFetched(_ :)),
                                               name: .didSavedNewData,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didNewDataFetched(_ :)),
                                               name: .didDeletedData,
                                               object: nil)
    }
    
    @objc func didNewDataFetched(_ notification: Notification) {
        CoreDataManager.shared.loadData { addNewEntityListSample in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.sortedListData = self.sortData(addNewEntityListSample)
                self.journalCollectionView.reloadData()
            }
        }
    }
    
    func loadCoreData(_ listData: AddNewEntityListSample) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.sortedListData = self.sortData(listData)
            self.journalCollectionView.reloadData()
        }
    }
    
    func sortData(_ list: AddNewEntityListSample) -> [AddNewEntity] { //MARK: - ???? sort hala sorun
        let sortedlist = list.sampleEntity.sorted { $0.moodDate! > $1.moodDate! }
        return sortedlist
    }
    
    func configureCollectionView() {
        journalCollectionView.register(UINib(nibName: "JournalPageCollectionCell", bundle: nil),
                                forCellWithReuseIdentifier: "JournalPageCollectionCell")
        journalCollectionView.delegate = self
        journalCollectionView.dataSource = self
    }
    
    func getCollectionViewCellSize(_ collectionView: UICollectionView, _ indexPathRow: Int) -> CGSize {
        if let textCount = sortedListData[indexPathRow].notesText?.count {
            switch textCount {
            case 0...50:
                return CGSize(width: collectionView.frame.width - 50, height: 100)
            case 51...200:
                return CGSize(width: collectionView.frame.width - 50, height: 150)
            case 201...400:
                return CGSize(width: collectionView.frame.width - 50, height: 200)
            case 401...500:
                return CGSize(width: collectionView.frame.width - 50, height: 250)
            default:
                return CGSize(width: collectionView.frame.width - 50, height: 200)
            }
        } else {
            return CGSize(width: collectionView.frame.width - 50, height: 200)
        }
    }
    
    @IBAction func infoButtonAct(_ sender: UIButton) {
        let infoVC = InfoViewController(.journalInfo)
        infoVC.modalTransitionStyle = .crossDissolve
        infoVC.modalPresentationStyle = .overCurrentContext
        present(infoVC, animated: true)
    }
    
}

extension JournalPageViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        getCollectionViewCellSize(collectionView, indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JournalPageCollectionCell", for: indexPath) as! JournalPageCollectionCell
        
        cell.journalCellTextView.text = sortedListData[indexPath.row].notesText
        cell.journalCellDateLabel.text = sortedListData[indexPath.row].moodDate?.dateToString("d MMM yyyy HH:mm")
        
        return cell
    }
}
