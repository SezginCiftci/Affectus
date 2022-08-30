//
//  SettingsViewController.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import UIKit

protocol SettingsViewControllerProtocol: AnyObject {
    
}

class SettingsViewController: UIViewController, SettingsViewControllerProtocol {
    
    @IBOutlet weak var settingsCollectionView: UICollectionView!
    
    var presenter: SettingsPresenterProtocol?
    
    var testArray = ["Disable Affectus", "Do u want to give us feedback?", "Give us star"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    func configureCollectionView() {
        settingsCollectionView.register(UINib(nibName: "SettingsCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "SettingsCell")
        settingsCollectionView.delegate = self
        settingsCollectionView.dataSource = self
    }
}

extension SettingsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 50, height: collectionView.frame.height/12)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingsCell", for: indexPath) as! SettingsCollectionViewCell
        cell.settingCellText.text = testArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


//Feedback
//Disable
//Do you want to give star? 
