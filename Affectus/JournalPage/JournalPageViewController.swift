//
//  JournalPageViewController.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.08.2022.
//

import UIKit

protocol JournalPageViewControllerProtocol: AnyObject {
    func loadCoreData(_ listData: AddNewEntityList)
}

class JournalPageViewController: UIViewController, JournalPageViewControllerProtocol {
    
    @IBOutlet weak var journalCollectionView: UICollectionView!
    var presenter: JournalPagePresenterProtocol?
    var listData: AddNewEntityList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        presenter?.notifyViewDidLoad()
    }
    
    func loadCoreData(_ listData: AddNewEntityList) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.listData = listData
            self.journalCollectionView.reloadData()
        }
    }
    
    func configureCollectionView() {
        journalCollectionView.register(UINib(nibName: "JournalPageCollectionCell", bundle: nil),
                                forCellWithReuseIdentifier: "JournalPageCollectionCell")
        journalCollectionView.delegate = self
        journalCollectionView.dataSource = self
    }
    
    @IBAction func backButtonAct(_ sender: UIButton) {
        presenter?.notifyBackButtonTapped()
    }
    
    func getCollectionViewCellSize(_ collectionView: UICollectionView, _ indexPathRow: Int) -> CGSize {
        if let textCount = listData?.notesTextArray[indexPathRow].count {
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
}

extension JournalPageViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        getCollectionViewCellSize(collectionView, indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData?.idArray.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JournalPageCollectionCell", for: indexPath) as! JournalPageCollectionCell
        
        cell.journalCellTextView.text = listData?.notesTextArray[indexPath.row]
        cell.journalCellDateLabel.text = listData?.moodDateArray[indexPath.row].dateToString("d MMM yyyy HH:mm")
        
        return cell
    }
}
