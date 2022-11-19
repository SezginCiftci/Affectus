//
//  AvatarPickViewController.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 16.11.2022.
//

import UIKit

class AvatarPickViewController: UIViewController {
    
    @IBOutlet weak var avatarPickCollectionView: UICollectionView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    func configureCollectionView() {
        avatarPickCollectionView.register(UINib(nibName: "AvatarCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "AvatarCell")
        avatarPickCollectionView.delegate = self
        avatarPickCollectionView.dataSource = self
    }
    
}

extension AvatarPickViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 50)/3, height: collectionView.frame.height/5)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        SettingsEntity.avatarArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as! AvatarCollectionViewCell
        cell.avatarCellImageView.image = UIImage(named: SettingsEntity.avatarArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.set(((indexPath.row) + 1), forKey: "Avatar")
        NotificationCenter.default.post(name: Notification.Name("Avatar Selected"), object: nil)
        dismiss(animated: true)
    }
}
