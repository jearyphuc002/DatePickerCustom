//
//  BDate.swift
//  DatePickerFPT
//
//  Created by Nguyen Thanh Phuc on 6/16/21.
//

import Foundation

class BDate {
    var day: String
    var month: String
    var year: String
    init(day: String, month: String, year: String) {
        self.day = day
        self.month = month
        self.year = year
    }
    class func getMonths() -> [String] {
        return ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    }
    // MARK: Get an array year when you pass in startYear and endYear. startYear must be greater than endYear.
    class func getYears(startYear: Int, endYear: Int) -> [String] {
        return CalendarHelper.fetchYears(startYear: startYear, endYear: endYear)
    }
}

public enum SelectionType {
    case square
    case roundedsquare
    case circle
}
