//
//  AnalizeViewController.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 28.07.2022.
//

import UIKit
import Charts

protocol AnalizeViewControllerProtocol: AnyObject {
    func loadCoreData(_ listData: AddNewEntityList)
}

class AnalizeViewController: UIViewController, AnalizeViewControllerProtocol {
    
    @IBOutlet weak var analizeChartView: AnalizeChartView!
    @IBOutlet weak var analizeCollectionView: UICollectionView!
    
    var presenter: AnalizePresenterProtocol?
    var listData: AddNewEntityList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        presenter?.notifyViewDidload()
    }
    
    func configureCollectionView() {
        analizeCollectionView.register(UINib(nibName: "AnalizeCell", bundle: nil),
                                forCellWithReuseIdentifier: "AnalizeCell")
        analizeCollectionView.delegate = self
        analizeCollectionView.dataSource = self
    }
    
    func loadCoreData(_ listData: AddNewEntityList) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.listData = listData
            self.analizeCollectionView.reloadData()
        }
    }
    
    @IBAction func backButtonAct(_ sender: UIButton) {
        presenter?.notifyBackButtonTapped()
    }
    
    @IBAction func journalButtonAct(_ sender: UIButton) {
        presenter?.notifyJournalButtonTapped()
    }
    
}

extension AnalizeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 20, height: collectionView.frame.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData?.idArray.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnalizeCell", for: indexPath) as! AnalizeCell
        
        cell.emotionLabel.text = listData?.moodDescribeArray[indexPath.row]
        cell.activityLabel.text = listData?.activitySelectionArray[indexPath.row]
        cell.timeLabel.text = listData?.moodDateArray[indexPath.row].dateToString("d MMM, HH:mm")
        cell.cellEmojiImageView.image = cell.generateCellImage(listData?.moodEmojiArray [indexPath.row] ?? 0)
        cell.layer.cornerRadius = 20
        
        return cell
    }
}
