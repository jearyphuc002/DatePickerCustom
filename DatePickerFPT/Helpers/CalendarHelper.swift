//
//  CalendarHelper.swift
//  DatePickerFPT
//
//  Created by Nguyen Thanh Phuc on 6/16/21.
//

import UIKit

class CalendarHelper {
    // MARK: Fetch an array year when you pass in startYear and endYear. startYear must be greater than endYear.
    static func fetchYears(startYear: Int, endYear: Int) -> [String] {
        var years: [String] = []
        if endYear > startYear {
            let range = endYear - startYear
            for index in 0...range {
                years.append(String(startYear + index))
            }
            return years
        } else {
            fatalError("startYear cannot be greater than EndYear")
        }
    }
    // MARK: Fetch total day of a Month.
    static func fetchDays(_ years: [ModelDate], _ months: [ModelDate]) -> Int {
        var numberDays: Int = 0 // Total day of a Month
        var currentMonth: String = "1"
        for (index, month) in months.enumerated() where month.isSelected {
            currentMonth = "\(index + 1)" // Get current month is selected.
            break
        }
        if let yearInt = Int(years.currentYear.type), let monthInt = Int(currentMonth) {
            let dateComponents = DateComponents(year: yearInt, month: monthInt)
            let calendar = Calendar.current
            guard let date = calendar.date(from: dateComponents) else { return 0 }
            guard let range = calendar.range(of: .day, in: .month, for: date) else {
                return 0
            }
            numberDays = range.count
        }
        return numberDays
    }
    // MARK: Get Date(MM, dd, YYYY).
    static func getThatDate(_ days: [ModelDate], _ months: [ModelDate], _ years: [ModelDate]) -> Date {
        var currentDay: String = ""
        var currentMonth: String = ""
        var currentYear: String = ""
        for day in days where day.isSelected {
            currentDay = day.type
            break
        }
        for month in months where month.isSelected {
            currentMonth = month.type
            break
        }
        for year in years where year.isSelected {
            currentYear = year.type
            break
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: "\(currentMonth)/\(currentDay)/\(currentYear)")
        guard let date = date else {
            return Date()
        }
        return date
    }
}

extension Array where Element: ModelDate {
    var currentYear: ModelDate {
        if let selectedYear = self.filter({ (modelObj) -> Bool in
            return modelObj.isSelected
        }).first {
            return selectedYear
        }
        return ModelDate(type: "2006", isSelected: false)
    }
    func selectDay(selectedDay: ModelDate) {
        for day in self where day == selectedDay {
            day.isSelected = selectedDay.isSelected
        }
    }
}
