//
//  EditOrDeletePopupView.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 1.08.2022.
//

import UIKit

protocol EditOrDeleteViewDelegate {
    func editButtonTapped()
    func deleteButtonTapped(_ selectedId: UUID)
    func dismissView()
}

class EditOrDeletePopupView: UIView {
    
    var editOrDeleteDelegate: EditOrDeleteViewDelegate?
    
    public var selectedId: UUID?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        if let viewForXib = Bundle.main.loadNibNamed("EditOrDeletePopupView", owner: self, options: nil)?[0] as? UIView {
            viewForXib.frame = self.bounds
            viewForXib.layer.cornerRadius = 16
            addSubview(viewForXib)
        }
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView(_:)))
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func dismissView(_ sender: UITapGestureRecognizer) {
        editOrDeleteDelegate?.dismissView()
    }
    
    @IBAction func editButtonAct(_ sender: Any) {
        editOrDeleteDelegate?.editButtonTapped()
    }
    
    @IBAction func deleteButtonAct(_ sender: Any) {
        editOrDeleteDelegate?.deleteButtonTapped(selectedId!)
    }
    
}
