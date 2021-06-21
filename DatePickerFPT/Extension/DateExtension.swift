//
//  DateExtension.swift
//  DatePickerFPT
//
//  Created by Nguyen Thanh Phuc on 6/19/21.
//

import Foundation

extension Date {
    var seprateDateInDDMMYY: (String, String, String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let arrDate = dateFormatter.string(from: self).components(separatedBy: "/")
        return (arrDate[0], arrDate[1], arrDate[2])
    }
}
