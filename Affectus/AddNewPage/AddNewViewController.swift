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
    func loadCoreData(noteText: String, moodEmoji: Int, moodDescribe: String, moodActivity: String, moodDate: Date, id: UUID)
}

class AddNewViewController: UIViewController, AddNewViewControllerProtocol, DatePickViewDelegate {
            
    @IBOutlet var emojiButtons: [UIButton]!
    @IBOutlet weak var addNewTextView: UITextView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var selectedEmotionsLabel: UILabel!
    @IBOutlet weak var selectedActivityLabel: UILabel!
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var addNewActivity: UIButton!
    @IBOutlet weak var addNewDescribe: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var presenter: AddNewPresenterProtocol?

    var didPickEmotionButtonTapped: Bool = false
    var isShowButtonTapped: Bool = false
    var chosenDate: Date?
    var showIndexes : (Int, UUID)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkShowButtonTapped()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isShowButtonTapped = false
    }
    
    func loadCoreData(noteText: String, moodEmoji: Int, moodDescribe: String, moodActivity: String, moodDate: Date, id: UUID) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.addNewTextView.text = noteText
            self.selectedEmotionsLabel.text = moodDescribe
            self.selectedActivityLabel.text = moodActivity
            self.dateButton.setTitle(moodDate.dateToString("d MMM "), for: .normal)
            self.emojiButtons[moodEmoji].alpha = 0.5
            for emojiButton in self.emojiButtons {
                emojiButton.isUserInteractionEnabled = false
            }
            self.addNewTextView.isUserInteractionEnabled = false
            self.addNewActivity.isUserInteractionEnabled = false
            self.addNewDescribe.isUserInteractionEnabled = false
            self.saveButton.isHidden = true
        }
    }
    
    func checkShowButtonTapped() {
        if isShowButtonTapped {
            if let showIndexes = showIndexes {
                presenter?.notifyShowButtonTapped(showIndexes.0, showIndexes.1)
            }
        }
    }
    
    func configureUI() {
        configureKeyboard()
        dateButton.isUserInteractionEnabled = false
        if !isShowButtonTapped {
            dateButton.setTitle(Date.now.dateToString("d MMM "), for: .normal)
            for emojiButton in emojiButtons {
                emojiButton.isUserInteractionEnabled = true
            }
            addNewTextView.isUserInteractionEnabled = true
            addNewActivity.isUserInteractionEnabled = true
            addNewDescribe.isUserInteractionEnabled = true
            saveButton.isHidden = false
        }
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
        if !isShowButtonTapped {
            let okButton = UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true)
            }
            let cancelButton = UIAlertAction(title: "CANCEL", style: .cancel)
            showAlertView(title: "Are you sure?", message: "If there are changes, these changes will be removed!", alertActions: [okButton, cancelButton])
        } else {
            self.dismiss(animated: true)
        }
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
