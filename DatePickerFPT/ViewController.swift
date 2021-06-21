//
//  ViewController.swift
//  DatePickerFPT
//
//  Created by Nguyen Thanh Phuc on 6/16/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var btnGetDate: UIButton!
    @IBOutlet weak var datePicker: FPTDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        customDatePicker()
        
    }
    func customDatePicker() {
        datePicker.yearRange(inBetween: 1990, end: 2022)
        datePicker.selectionType = .circle
        datePicker.bgColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        datePicker.deselectTextColor = UIColor.init(white: 1.0, alpha: 0.7)
        datePicker.deselectedBgColor = .clear
        datePicker.selectedBgColor = .white
        datePicker.selectedTextColor = .black
        datePicker.intialDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
//         datePicker.delegate = self
    }
    @IBAction func getDate(_ sender: UIButton) {
        let date = datePicker.getSelectedDate()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d, yyyy"
        btnGetDate.setTitle(dateformatter.string(from: date), for: .normal)
    }

}
