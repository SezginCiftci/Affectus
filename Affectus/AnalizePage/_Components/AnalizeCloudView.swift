//
//  AnalizeCloudView.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 9.08.2022.
//

import UIKit

class AnalizeCloudView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        if let viewForXib = Bundle.main.loadNibNamed("AnalizeCloudView", owner: self, options: nil)?[0] as? UIView {
            viewForXib.frame = self.bounds
            viewForXib.layer.cornerRadius = 16
            addSubview(viewForXib)
        }
    }
}
