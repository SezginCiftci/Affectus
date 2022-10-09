//
//  SettingsViewController.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import UIKit
import MessageUI

protocol SettingsViewControllerProtocol: AnyObject {
    
}

class SettingsViewController: UIViewController, SettingsViewControllerProtocol {
    
    @IBOutlet weak var settingsCollectionView: UICollectionView!
    @IBOutlet weak var settingsProfileImageView: UIImageView!
    
    var presenter: SettingsPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsProfileImageView.image = generateProfileImageView()
    }
    
    func configureCollectionView() {
        settingsCollectionView.register(UINib(nibName: "SettingsCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "SettingsCell")
        settingsCollectionView.delegate = self
        settingsCollectionView.dataSource = self
    }
    
    func generateProfileImageView() -> UIImage {
        return UIImage(named: "philosopher-\(String(Int.random(in: 1...10)))") ?? UIImage()
    }
    
    func didGiveUsStarCellTapped() {
        presenter?.notifyGiveStarCellTapped()
    }
    
    func didGiveFeedbackCellTapped() {
        presenter?.notifyGiveFeedbackCellTapped(self)
    }
    
    func didDisableAffectusCellTapped() {
        presenter?.notifyDisableCellTapped()
    }
    
}

extension SettingsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 50, height: collectionView.frame.height/10)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SettingsEntity.settingsCellTextArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingsCell", for: indexPath) as! SettingsCollectionViewCell
        cell.settingCellText.text = SettingsEntity.settingsCellTextArray[indexPath.row]
        cell.settingsCellImageView.image = UIImage(named: SettingsEntity.settingsCellImage[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            didGiveFeedbackCellTapped()
        case 1:
            didGiveFeedbackCellTapped()
        case 2:
            didDisableAffectusCellTapped()
        default:
            break
        }
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true)
        }
        
        switch result {
        case .cancelled:
            print("canceled")
        case .saved:
            print("saved")
        case .sent:
            self.animateWithImage("checked")
            print("sent")
        case .failed:
            print("failed")
        @unknown default:
            fatalError()
        }
        
        controller.dismiss(animated: true)
    }
}
