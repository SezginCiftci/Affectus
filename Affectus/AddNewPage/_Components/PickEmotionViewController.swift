//
//  PickEmotionViewController.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 2.08.2022.
//

import UIKit

protocol PickEmotionViewControllerDelegate: AnyObject {
    func getSelectedItems(_ selectedItems: [String])
}

class PickEmotionViewController: UIViewController {
    
    @IBOutlet weak var pickEmotionCollectionView: UICollectionView!
    
    weak var pickEmotionDelegate: PickEmotionViewControllerDelegate?
    
    var pickEmotionArray: [String]?
    var selectedEmotions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureGestureRecognizer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func configureGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView(_:)))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func dismissView(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    func configureCollectionView() {
        pickEmotionCollectionView.register(UINib(nibName: "PickEmotionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PickEmotionCollectionViewCell")
        pickEmotionCollectionView.delegate = self
        pickEmotionCollectionView.dataSource = self
    }
    
    @IBAction func saveButtonAct(_ sender: UIButton) {
        pickEmotionDelegate?.getSelectedItems(selectedEmotions)
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelButtonAct(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

extension PickEmotionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/2) - 10, height: (collectionView.frame.height/4))
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pickEmotionArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PickEmotionCollectionViewCell", for: indexPath) as! PickEmotionCollectionViewCell
        cell.pickEmotionCellDelegate = self
        cell.pickCellButton.setTitle(pickEmotionArray?[indexPath.row], for: .normal)
        cell.pickCellButton.setTitleColor(.white, for: .normal)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
}

extension PickEmotionViewController: PickEmotionCellDelegate {
    
    func addItemToEmotion(_ selectedItem: String) {
        selectedEmotions.append(selectedItem)
    }
    
    func deleteItemFromemotion(_ selectedItem: String) {
        if let index = selectedEmotions.firstIndex(of: selectedItem) {
            selectedEmotions.remove(at: index)
        }
    }
}
