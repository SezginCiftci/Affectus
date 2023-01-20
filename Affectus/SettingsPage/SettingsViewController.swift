//
//  SettingsViewController.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import UIKit
import MessageUI
import PassKit

protocol SettingsViewControllerProtocol: AnyObject {
    func deletedAllSuccess()
    func deletedAllError()
}

class SettingsViewController: UIViewController, SettingsViewControllerProtocol {
    
    @IBOutlet weak var settingsCollectionView: UICollectionView!
    @IBOutlet weak var settingsProfileImageView: UIImageView!
    
    var presenter: SettingsPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        addGestureRecognizerImageView()
        addAvatarObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureProfileImage()
    }
    
    func configureCollectionView() {
        settingsCollectionView.register(UINib(nibName: "SettingsCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "SettingsCell")
        settingsCollectionView.delegate = self
        settingsCollectionView.dataSource = self
    }
    
    func addAvatarObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(configureProfileImage), name: Notification.Name("Avatar Selected"), object: nil)

    }
    
    func addGestureRecognizerImageView() {
        let gestureReconizer = UITapGestureRecognizer(target: self, action: #selector(gestureTapped))
        settingsProfileImageView.isUserInteractionEnabled = true
        settingsProfileImageView.addGestureRecognizer(gestureReconizer)
    }
    
    @objc func gestureTapped() {
        let avatarVC = AvatarPickViewController()
        present(avatarVC, animated: true)
    }
    
    @objc func configureProfileImage() {
        let savedAvatar = UserDefaults.standard.integer(forKey: "Avatar")
        if savedAvatar == 0 {
            settingsProfileImageView.image = generateRandomProfileImageView()
        } else {
            settingsProfileImageView.image = UIImage(named: "avatar-\(String(savedAvatar))")
        }
    }
    
    func generateRandomProfileImageView() -> UIImage {
        return UIImage(named: "avatar-\(String(Int.random(in: 1...12)))") ?? UIImage()
    }
    
    func didGiveUsStarCellTapped() {
        presenter?.notifyGiveStarCellTapped()
    }
    
    func didGiveFeedbackCellTapped() {
        presenter?.notifyGiveFeedbackCellTapped(self)
    }
    
    func didDisableAffectusCellTapped() {
        let okAction = UIAlertAction(title: "Yes, I am", style: .default) { _ in
            let okButton = UIAlertAction(title: "OK", style: .default) { _ in
                self.presenter?.notifyDisableCellTapped()
            }
            self.showAlertView(title: "Goodbye...", message: "You can come here anytime you like.", alertActions: [okButton])
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        self.showAlertView(title: "Are You Sure?", message: "All the information you provided will be deleted. We are going to miss you :(", alertActions: [cancelAction, okAction])
    }
    
    func deletedAllSuccess() {
        animateWithImage("checked")
    }
    
    func deletedAllError() {
        animateWithImage("cancel")
    }
    
    @IBAction func infoButtonAct(_ sender: UIButton) {
        let infoVC = InfoViewController(.settingInfo)
        infoVC.modalTransitionStyle = .crossDissolve
        infoVC.modalPresentationStyle = .overCurrentContext
        present(infoVC, animated: true)
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
//        switch indexPath.row {
//        case 0:
//            didGiveUsStarCellTapped()
//        case 1:
//            didGiveFeedbackCellTapped()
//        case 2:
//            didDisableAffectusCellTapped()
//        default:
//            break
//        }
        switch indexPath.row {
        case 0:
            didGiveFeedbackCellTapped()
        case 1:
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
            animateWithImage("cancel")
        case .saved:
            print("saved")
        case .sent:
            animateWithImage("checked")
        case .failed:
            animateWithImage("cancel")
        @unknown default:
            fatalError()
        }
        controller.dismiss(animated: true)
    }
}

extension SettingsViewController {
    
}
