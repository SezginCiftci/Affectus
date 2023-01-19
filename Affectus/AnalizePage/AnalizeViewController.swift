//
//  AnalizeViewController.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 28.07.2022.
//

import UIKit
import FSCalendar

protocol AnalizeViewControllerProtocol: AnyObject {
    func loadCoreData(_ listData: AddNewEntityList)
}

class AnalizeViewController: UIViewController, AnalizeViewControllerProtocol {
    
    @IBOutlet weak var analizeChartView: AnalizeChartView!
    @IBOutlet weak var analizeCollectionView: UICollectionView!
    @IBOutlet weak var fscalender: FSCalendar!
    
    var presenter: AnalizePresenterProtocol?
    var listData: AddNewEntityList?
    
    let formatter = DateFormatter()
    private var isPageFirstTimeShown = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //presenter?.notifyViewDidload()
        configureCollectionView()
        self.configureCalender()
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
    
    func configureCalender() {
//        fscalender.appearance.todayColor = .white
        fscalender.delegate = self
        fscalender.dataSource = self
    }
    @IBAction func infoButtonAct(_ sender: UIButton) {
        let infoVC = InfoViewController(.analizeInfo)
        infoVC.modalTransitionStyle = .crossDissolve
        infoVC.modalPresentationStyle = .overCurrentContext
        present(infoVC, animated: true)
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
    
    func fetchDataForCalender(_ completion: (_ listData: AddNewEntityList) -> ()) {
        CoreDataManager.shared.loadData { addNewEntityList in
            self.listData = addNewEntityList
            guard let listData = listData else {
                return
            }
            completion(listData)
        }
    }
}

extension AnalizeViewController: FSCalendarDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        fetchDataForCalender { listData in
            self.listData = listData
        }
        guard let list = listData?.moodDateArray else { return UIColor() }
        for (index, _) in list.enumerated() {
            let testDate = list[index].dateToString("dd-MM-yyyy") 
            formatter.dateFormat = "dd-MM-yyyy"
            
            guard let excludedDate = formatter.date(from: testDate) else { return nil}
            if date.compare(excludedDate) == .orderedSame {
                return .systemPurple
            }
        }
        isPageFirstTimeShown = false
        return nil
    }
}
