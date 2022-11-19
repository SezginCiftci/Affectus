//
//  ReusableView.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 9.10.2022.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "HeaderCollectionReusableView"
    
    private var headerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.backgroundColor = .white
        return view
    }()
    
    private var headerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.sizeToFit()
        iv.backgroundColor = .clear
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    private var headerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 6
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .black
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var headerImage: UIImage {
        return UIImage(named: "philosopher-\(String(Int.random(in: 1...10)))") ?? UIImage()
    }
    
    var headerTitle: String {
        let quotesArray = ConstantQuotes().quotesArray
        return quotesArray[Int.random(in: 0...quotesArray.count-1)]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureHeaderView()
    }
    
    func updateHeaderView(_ headerImage: UIImage, _ headerText: String) {
        headerImageView.image = headerImage
        headerLabel.text = headerText
    }
    
    func configureHeaderView() {
        self.backgroundColor = UIColor(red: 213/255, green: 233/255, blue: 246/255, alpha: 1)
        
        self.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            headerView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            headerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25)
        ])
        
        headerView.addSubview(headerImageView)
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            headerImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
            headerImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
            headerImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        headerView.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerImageView.trailingAnchor, constant: 20),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 25),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -25)
        ])
    }
    
}
