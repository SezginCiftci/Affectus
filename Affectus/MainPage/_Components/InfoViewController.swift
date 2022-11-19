//
//  InfoViewController.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 17.11.2022.
//

import UIKit

enum InfoPageType {
    case homeInfo
    case analizeInfo
    case journalInfo
    case settingInfo
}

class InfoViewController: UIViewController {
    
    let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()
    
    let bubbleImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "bubble")
        return iv
    }()
    
    let bubbleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = UIColor(red: 59/255, green: 52/255, blue: 134/255, alpha: 1)
        label.backgroundColor = .clear
        label.numberOfLines = 6
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        return label
    }()
    
    private var infoPageType: InfoPageType
    
    init(_ infoPageType: InfoPageType) {
        self.infoPageType = infoPageType
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(.homeInfo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInfoUI()
    }
    
    private func configureInfoUI() {
        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.addSubview(bubbleImageView)
        NSLayoutConstraint.activate([
            bubbleImageView.widthAnchor.constraint(equalToConstant: 300),
            bubbleImageView.heightAnchor.constraint(equalToConstant: 300),
            bubbleImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            bubbleImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70)
        ])

        bubbleImageView.addSubview(bubbleLabel)
        NSLayoutConstraint.activate([
            bubbleLabel.centerXAnchor.constraint(equalTo: bubbleImageView.centerXAnchor),
            bubbleLabel.widthAnchor.constraint(equalToConstant: 220),
            bubbleLabel.topAnchor.constraint(equalTo: bubbleImageView.topAnchor, constant: 80),
            bubbleLabel.bottomAnchor.constraint(equalTo: bubbleImageView.bottomAnchor, constant: -40)
        ])
        bubbleLabel.text = getInfoLabelText()

        addGestureToView()
    }
    
    private func getInfoLabelText() -> String {
        switch infoPageType {
        case .homeInfo:
            return "You can add an daily mood by clicking plus button from the below. While your daily moods are listed on home page, analize page will show further insight as well."
        case .analizeInfo:
            return "To see proper analize on this page, you should enter at least two daily mood. By the way purple dates on calender refer to dates you entered mood."
        case .journalInfo:
            return "Journal page only includes your notes about daily mood. You can use here as your personal journal."
        case .settingInfo:
            return "On this page, you can determine your personal Avatar by clicking image. Moreover, you can give us star, feedback and also you can delete all of your information in Affectus without deleting app."
        }
        
    }
    
    private func addGestureToView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissInfoView))
        backgroundView.addGestureRecognizer(gesture)
    }
    
    @objc private func dismissInfoView() {
        dismiss(animated: true)
    }
}
