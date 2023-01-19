//
//  PickEmotionCollectionViewCell.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 2.08.2022.
//

import UIKit

protocol PickEmotionCellDelegate: AnyObject {
    func addItemToEmotion(_ selectedItem: String)
    func deleteItemFromemotion(_ selectedItem: String)
}

class PickEmotionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pickCellButton: UIButton!
    
    weak var pickEmotionCellDelegate: PickEmotionCellDelegate?
        
    var buttonState: Bool = false {
        didSet {
            if buttonState == false {
                pickCellButton.backgroundColor = UIColor(named: "cellGradientEndColour")
                removeItem()
            } else {
                pickCellButton.backgroundColor = UIColor(named: "cellGradientStartColour")
                appendItem()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func removeItem() {
        pickEmotionCellDelegate?.deleteItemFromemotion((pickCellButton.titleLabel?.text)!)
    }

    func appendItem() {
        pickEmotionCellDelegate?.addItemToEmotion((pickCellButton.titleLabel?.text)!)
    }

    @IBAction func pickCellButtonAct(_ sender: UIButton) {
        buttonState.toggle()
    }
}
