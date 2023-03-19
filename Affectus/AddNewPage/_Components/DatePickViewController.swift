//
//  DatePickViewController.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 1.08.2022.
//

import UIKit

protocol DatePickViewDelegate: AnyObject {
    func getSelectedDate(_ selectedDate: Date)
}

class DatePickViewController: UIViewController {
    
    var dateDelegate: DatePickViewDelegate?
    var selectedDate: Date?
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissDatePicker(_:)))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func dismissDatePicker(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    @IBAction func datePickerAct(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }
    
    @IBAction func doneButtonAct(_ sender: Any) {
        dateDelegate?.getSelectedDate(selectedDate ?? .now)
        self.dismiss(animated: true)
    }
}
