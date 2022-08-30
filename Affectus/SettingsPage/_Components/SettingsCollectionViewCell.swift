//
//  SettingsCollectionViewCell.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 5.08.2022.
//

import UIKit

class SettingsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var settingCellText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCellColor()
    }
    
    func configureCellColor() {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
        guard let starterColour = UIColor(named: "cellGradientStartColour")?.cgColor else { return }
        guard let endColour = UIColor(named: "cellGradientEndColour")?.cgColor else { return }
        layer.colors = [starterColour, endColour]
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)

        contentView.layer.addSublayer(layer)
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.frame = contentView.bounds
        contentView.layer.insertSublayer(layer, at: 0)
    }
}
