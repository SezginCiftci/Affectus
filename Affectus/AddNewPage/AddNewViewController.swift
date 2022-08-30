//
//  AddNewViewController.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import UIKit

protocol AddNewViewControllerProtocol: AnyObject {
    
}

class AddNewViewController: UIViewController, AddNewViewControllerProtocol, DatePickViewDelegate {
            
    @IBOutlet var emojiButtons: [UIButton]!
    @IBOutlet weak var addNewTextView: UITextView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var selectedEmotionsLabel: UILabel!
    @IBOutlet weak var selectedActivityLabel: UILabel!
    @IBOutlet weak var charCountLabel: UILabel!
    
    var presenter: AddNewPresenterProtocol?

    var didPickEmotionButtonTapped: Bool = false    
    var chosenDate: Date?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func configureUI() {
        configureKeyboard()
        dateButton.setTitle(Date.now.dateToString("d MMM "), for: .normal)
    }
    
    func configureKeyboard() {
        addNewTextView.delegate = self
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        addNewTextView.inputAccessoryView = toolBar
    }

    @objc func dismissKeyboard() {
        if addNewTextView.text.count > 500 {
            let alert = UIAlertController(title: "Error!", message: "Charachter limit is 500.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(okButton)
            present(alert, animated: true)
        } else {
            view.endEditing(true)
        }
    }
    
    @IBAction func dateButtonAct(_ sender: UIButton) {
        presenter?.notifyDateButtonTapped(self)
    }
    
    @IBAction func exitButtonAct(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure?", message: "Information you've written will be deleted!", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        let cancelButton = UIAlertAction(title: "CANCEL", style: .cancel)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    @IBAction func emojiButtonsAct(_ sender: UIButton) {
        for i in 0...4 {
            emojiButtons[i].alpha = 1
        }
        emojiButtons[sender.tag].alpha = 0.5
    }
    
    @IBAction func addEmotionButtonAct(_ sender: UIButton) {
        didPickEmotionButtonTapped = true
        presenter?.notifyPickEmotionAndActivityButtonTapped(PickEmotionEntity().emotionArray, self)
    }
    
    @IBAction func addActivityButtonAct(_ sender: UIButton) {
        didPickEmotionButtonTapped = false
        presenter?.notifyPickEmotionAndActivityButtonTapped(PickEmotionEntity().activityArray, self)
    }
    
    func getSelectedDate(_ selectedDate: Date) {
        chosenDate = selectedDate
        if selectedDate != .now {
            dateButton.setTitle(selectedDate.dateToString("d MMM "), for: .normal)
        }
    }
    
    @IBAction func saveButtonAct(_ sender: UIButton) {
        
        if let selectedButton = getSelectedButton() {
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.presenter?.notifySaveButtonTapped(UUID(), self.chosenDate ?? .now, self.addNewTextView.text ?? "N/A", selectedButton, self.selectedEmotionsLabel.text ?? "N/A", self.selectedActivityLabel.text ?? "N/A")
                
                
                self.animateSuccessImage("checked")
                NotificationCenter.default.post(name: NSNotification.Name("new"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            let okButton = UIAlertAction(title: "OK", style: .cancel)
            showAlertView(title: "Error!", message: "You should choose one of emojis!", alertActions: [okButton])
        }
        
    }
    
    func getSelectedButton() -> Int? {
        for (index, i) in emojiButtons.enumerated() {
            if i.alpha == 0.5 {
                return index
            }
        }
        return nil
    }
}

extension AddNewViewController: UITextViewDelegate {

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        charCountLabel.text = "\(String(addNewTextView.text.count))/500"
        if addNewTextView.text.count > 500 {
            charCountLabel.textColor = .red
        } else {
            charCountLabel.textColor = .black
        }
    }
    
    //    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    //        return true
    //    }
}

extension AddNewViewController: PickEmotionViewControllerDelegate {
    func getSelectedItems(_ selectedItems: [String]) {
        let emotionsString = selectedItems.joined(separator: ", ")
        if didPickEmotionButtonTapped {
            selectedEmotionsLabel.text = emotionsString
        } else {
            selectedActivityLabel.text = emotionsString
        }
    }
}

enum DummyTextCheck: String {
    case na = "N/A"
    case selectedEmotions = "Which emotion describes your state?"
    case selectedActivities = "What are you going to do today?"
    case emptyString = ""
}
