//
//  AddNewViewController.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import UIKit

protocol AddNewViewControllerProtocol: AnyObject {
    func dismissViewController()
    func saveDataFailed()
    func loadDataWithEdition(_ moodDate: Date,
                             _ noteText: String,
                             _ moodEmoji: Int,
                             _ emotionSelection: String,
                             _ activitySelection: String)
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
    
    var isEditButtonTapped: Bool = false
    var editionIdAndIndex: (a: UUID, b: Int)? {
        didSet {
            if let editionId = editionIdAndIndex?.a, let editionIndex = editionIdAndIndex?.b {
                presenter?.notifyEditButtonTapped(editionId, editionIndex)
                isEditButtonTapped = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadDataWithEdition(_ moodDate: Date,
                             _ noteText: String,
                             _ moodEmoji: Int,
                             _ emotionSelection: String,
                             _ activitySelection: String) {
        dateButton.setTitle(moodDate.dateToString("d MMM "), for: .normal)
        addNewTextView.text = noteText
        emojiButtons[moodEmoji].alpha = 0.5
        selectedEmotionsLabel.text = emotionSelection
        selectedActivityLabel.text = activitySelection
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
        view.endEditing(true)
    }
    
    @IBAction func dateButtonAct(_ sender: UIButton) {
        presenter?.notifyDateButtonTapped(self)
    }
    
    @IBAction func exitButtonAct(_ sender: UIButton) {
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true)
        }
        let cancelButton = UIAlertAction(title: "CANCEL", style: .cancel)
        showAlertView(title: "Are you sure?", message: "If there are changes, these changes will be removed!", alertActions: [okButton, cancelButton])
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
    }
    
    @IBAction func saveButtonAct(_ sender: UIButton) {
        
        checkTextViewIsEmpty()
        checkSelectedEmotionsIsEmpty()
        checkSelectedActivityIsEmpty()
        
        if !isEditButtonTapped {
            if let selectedButton = getSelectedButton(),
                let emotionText = selectedEmotionsLabel.text,
                let activityText = selectedActivityLabel.text {
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.presenter?.notifySaveButtonTapped(UUID(),
                                                           self.chosenDate ?? .now,
                                                           self.addNewTextView.text ?? "",
                                                           selectedButton,
                                                           emotionText,
                                                           activityText)
                }
            } else {
                let okButton = UIAlertAction(title: "OK",
                                             style: .cancel)
                showAlertView(title: "Error!",
                              message: "You should choose one of emojis!",
                              alertActions: [okButton])
            }
        } else {
            if let selectedButton = getSelectedButton(),
                let emotionText = selectedEmotionsLabel.text,
                let activityText = selectedActivityLabel.text,
                let editId = editionIdAndIndex?.a,
                let editIndex = editionIdAndIndex?.b{
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.presenter?.notifySaveButtonTappedWithEdit(UUID(),
                                                                   self.chosenDate ?? .now,
                                                                   self.addNewTextView.text ?? "",
                                                                   selectedButton,
                                                                   emotionText,
                                                                   activityText,
                                                                   editId,
                                                                   editIndex)
                }
            } else {
                let okButton = UIAlertAction(title: "OK",
                                             style: .cancel)
                showAlertView(title: "Error!",
                              message: "You should choose one of emojis!",
                              alertActions: [okButton])
            }
        }
    }
    
    func checkTextViewIsEmpty() {
        addNewTextView.text.isEmpty || addNewTextView.text == nil ? addNewTextView.text = "- -" : nil
    }
    
    func checkSelectedEmotionsIsEmpty() {
        selectedEmotionsLabel.text!.isEmpty || selectedEmotionsLabel.text == nil || selectedEmotionsLabel.text == DummyTextCheck.selectedEmotions ? selectedEmotionsLabel.text = "- -" : nil
    }
    
    func checkSelectedActivityIsEmpty() {
        selectedActivityLabel.text!.isEmpty || selectedActivityLabel.text == nil || selectedActivityLabel.text == DummyTextCheck.selectedActivities ? selectedActivityLabel.text = "- -" : nil
    }
    
    func dismissViewController() {
        animateWithImage("checked")
    }
    
    func saveDataFailed() {
        let okButton = UIAlertAction(title: "OK", style: .cancel)
        showAlertView(title: "Error!",
                      message: "Something went wrong, try again later.",
                      alertActions: [okButton])
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
        if addNewTextView.text.count >= 500 {
            charCountLabel.textColor = .red
        } else {
            charCountLabel.textColor = .black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 500
    }
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

class DummyTextCheck {
    static let na = "N/A"
    static let selectedEmotions = "Which emotion describes your state?"
    static let selectedActivities = "What are you going to do today?"
    static let doubleSeperator = "- -"
}
