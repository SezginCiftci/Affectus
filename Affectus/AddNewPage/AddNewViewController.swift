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
    
    func deleteItemWithSuccess()
    func deleteItemWithError()
}

class AddNewViewController: UIViewController, AddNewViewControllerProtocol, DatePickViewDelegate {
            
    @IBOutlet weak var addNewTextView: UITextView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var selectedEmotionsLabel: UILabel!
    @IBOutlet weak var selectedActivityLabel: UILabel!
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var addNewActivity: UIButton!
    @IBOutlet weak var addNewDescribe: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var moodImageview: UIImageView!
    @IBOutlet weak var moodSlider: UISlider!
    
    var presenter: AddNewPresenterProtocol?

    var didPickEmotionButtonTapped: Bool = false
    var isShowButtonTapped: Bool = false
    var chosenDate: Date?
    var showUUID: UUID?
    
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
            self.setSlider(value: Float(moodEmoji))
        }
    }
    
    func checkShowButtonTapped() {
        if isShowButtonTapped {
            if let showUUID = showUUID {
                presenter?.notifyShowButtonTapped(showUUID)
            }
        }
    }
    
    func deleteItemWithSuccess() {
        if let emotionText = selectedEmotionsLabel.text,
           let activityText = selectedActivityLabel.text {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.presenter?.notifySaveButtonTapped(UUID(),
                                                       self.chosenDate ?? .now,
                                                       self.addNewTextView.text ?? "",
                                                       Int(self.moodSlider.value),
                                                       emotionText,
                                                       activityText)
            }
        }
    }
    
    func deleteItemWithError() {
        showAlertView(title: "Error!", message: "Something went wrong", alertActions: [])
    }
    
    func configureUI() {
        configureKeyboard()
        dateButton.isUserInteractionEnabled = true
        dateButton.setTitle(Date.now.dateToString("d MMM "), for: .normal)
        moodSlider.isUserInteractionEnabled = true
        addNewTextView.isUserInteractionEnabled = true
        addNewActivity.isUserInteractionEnabled = true
        addNewDescribe.isUserInteractionEnabled = true
        saveButton.isEnabled = true
        saveButton.alpha = 1
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
            showAlertView(title: "Are you sure?", message: "If there are any changes, these changes will be removed!", alertActions: [okButton, cancelButton])
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func moodSliderValueDidChange(_ sender: UISlider) {
        setSlider(value: sender.value)
    }
    
    private func setSlider(value: Float) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            switch value {
            case 0..<0.5:
                self.moodSlider.value = 0
                self.moodImageview.image = UIImage(named: MoodImageNames.Cry.rawValue)
            case 0.5..<1.5:
                self.moodSlider.value = 1
                self.moodImageview.image = UIImage(named: MoodImageNames.Sad.rawValue)
            case 1.5..<2.5:
                self.moodSlider.value = 2
                self.moodImageview.image = UIImage(named: MoodImageNames.Confusing.rawValue)
            case 2.5..<3.5:
                self.moodSlider.value = 3
                self.moodImageview.image = UIImage(named: MoodImageNames.Happy.rawValue)
            case 3.5...4:
                self.moodSlider.value = 4
                self.moodImageview.image = UIImage(named: MoodImageNames.Smile.rawValue)
            default:
                break
            }
        }
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
        dateButton.setTitle(selectedDate.dateToString("d MMM "), for: .normal)
    }
    
    @IBAction func saveButtonAct(_ sender: UIButton) {
        
        guard let dateIsSelected = presenter?.isTodayDateGiven(selectedDate: self.chosenDate ?? .now) else {
            print("Something went wrong")
            return
        }
        
        if dateIsSelected {
            showAlertView(title: "Error", message: "This date is already given. Pick another date", alertActions: [])
        } else {
            checkTextViewIsEmpty()
            checkSelectedEmotionsIsEmpty()
            checkSelectedActivityIsEmpty()

            if !isShowButtonTapped {
                if let emotionText = selectedEmotionsLabel.text,
                   let activityText = selectedActivityLabel.text {

                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.presenter?.notifySaveButtonTapped(UUID(),
                                                               self.chosenDate ?? .now,
                                                               self.addNewTextView.text ?? "",
                                                               Int(self.moodSlider.value),
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
                presenter?.notifyEditSaveButtonTapped(showUUID!)
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

enum MoodImageNames: String {
    case Cry = "cry"
    case Sad = "sad"
    case Confusing = "confused"
    case Happy = "happy"
    case Smile = "smile"
}
