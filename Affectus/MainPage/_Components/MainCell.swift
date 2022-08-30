//
//  MainCell.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import UIKit

class MainCell: UICollectionViewCell {
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var cellImageview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
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

        gradientView.layer.addSublayer(layer)
        gradientView.layer.cornerRadius = 20
        gradientView.layer.masksToBounds = true
        gradientView.frame = contentView.bounds
        gradientView.layer.insertSublayer(layer, at: 0)
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
