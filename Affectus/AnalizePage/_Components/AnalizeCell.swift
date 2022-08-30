//
//  AnalizeCell.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 8.08.2022.
//

import UIKit

class AnalizeCell: UICollectionViewCell {
    
    @IBOutlet weak var cellEmojiImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    
    override class func awakeFromNib() {
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
        contentView.alpha = 0.7
    }
    
    func generateCellImage(_ imageIndex: Int) -> UIImage {
        switch imageIndex {
        case 0:
            return UIImage(named: "cry") ?? UIImage()
        case 1:
            return UIImage(named: "sad") ?? UIImage()
        case 2:
            return UIImage(named: "confused") ?? UIImage()
        case 3:
            return UIImage(named: "happy") ?? UIImage()
        case 4:
            return UIImage(named: "smile") ?? UIImage()
        default:
            return UIImage(named: "confused") ?? UIImage()
        }
    }
}
