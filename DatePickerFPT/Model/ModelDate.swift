//
//  ModelDate.swift
//  DatePickerFPT
//
//  Created by Nguyen Thanh Phuc on 6/16/21.
//

import Foundation

class ModelDate {
    var type: String
    var isSelected: Bool
    init(type: String, isSelected: Bool = false) {
        self.type = type
        self.isSelected = isSelected
    }
}
extension ModelDate: InfiniteScollingData {}

extension ModelDate {
    class func getYears(startYear: Int = 1980, endYear: Int = 2018) -> [ModelDate] {
        let years = BDate.getYears(startYear: startYear, endYear: endYear)
        var arrYears: [ModelDate] = []
        for index in 0..<years.count {
            arrYears.append(ModelDate(type: years[index], isSelected: false))
        }
        return arrYears
    }
    class func getMonths() -> [ModelDate] {
        let months = BDate.getMonths()
        var arrMonths: [ModelDate] = []
        for index in 0..<months.count {
            let item = ModelDate(type: months[index], isSelected: false)
            arrMonths.append(item)
        }
        return arrMonths
    }
    class func getDays(_ years: [ModelDate], _ months: [ModelDate]) -> [ModelDate] {
        let days = CalendarHelper.fetchDays(years, months)
        return ModelDate.dayUpTo(lastDayInt: days)
    }
}

extension ModelDate {
    class func dayUpTo(lastDayInt: Int) -> [ModelDate] {
        return (1...lastDayInt).map { (dayInt) -> ModelDate in
            return ModelDate(type: "\(dayInt)")
        }
    }
}

extension ModelDate: Equatable {
    static func == (lhs: ModelDate, rhs: ModelDate) -> Bool {
        return lhs.type == rhs.type
    }
}
