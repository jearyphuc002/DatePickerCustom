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
        let arrDate = dateFormatter.string(from: self).components(separatedBy: "/") // arrDate = [ "06", "21", "2021"]
        return (arrDate[0], arrDate[1], arrDate[2]) // return a Tuple ("06", "21", "2021")
    }
}
