//
//  DatePicker.swift
//  DatePickerFPT
//
//  Created by Nguyen Thanh Phuc on 6/19/21.
//

import UIKit

public protocol FPTDatePickerDelegate {
    func FPTDatePicker(didChange date: Date)
}

open class FPTDatePicker: UIView {
    @IBOutlet weak var dateRow: UICollectionView!
    @IBOutlet weak var monthRow: UICollectionView!
    @IBOutlet weak var yearRow: UICollectionView!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var selectionView: UIView!
    private var years = ModelDate.getYears() // Get Years
    private let months = ModelDate.getMonths() // Get Month
    private var currentDay = "31"
    private var days: [ModelDate] = [] // Array days for a month
    var infiniteScrollingBehaviourForYears: InfiniteScrollingBehaviour! // behaviour scroll year
    var infiniteScrollingBehaviourForDays: InfiniteScrollingBehaviour! // behaviour scroll day
    var infiniteScrollingBehaviourForMonths: InfiniteScrollingBehaviour! // behaviour scroll month
    // Accessible Properties
    public var bgColor: UIColor = #colorLiteral(red: 0.5564764738, green: 0.754239738, blue: 0.6585322022, alpha: 1) // background color
    public var selectedBgColor: UIColor = .white
    public var selectedTextColor: UIColor = .white
    public var deselectedBgColor: UIColor = .clear
    public var deselectTextColor: UIColor = UIColor.init(white: 1.0, alpha: 0.7)
    public var fontFamily: UIFont = UIFont(name: "GillSans-SemiBold", size: 20)!
    public var selectionType: SelectionType = .roundedsquare
    public var intialDate: Date = Date()
    public var delegate: FPTDatePickerDelegate?
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadinit()
        registerCell()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadinit()
        registerCell()
    }
    // MARK: Register Cell for CollectionViewCell Day Month Years.
    private func registerCell() {
        let bundle = Bundle(for: self.classForCoder)
        let nibName = UINib(nibName: "DatePickerCollectionViewCell", bundle: bundle)
        dateRow.register(nibName, forCellWithReuseIdentifier: "cell")
        monthRow.register(nibName, forCellWithReuseIdentifier: "cell")
        yearRow.register(nibName, forCellWithReuseIdentifier: "cell")
    }
    private func loadinit() {
        let bundle = Bundle(for: self.classForCoder)
        bundle.loadNibNamed("FPTDatePicker", owner: self, options: nil)
        addSubview(calendarView)
        calendarView.frame = self.bounds
        delay(0.1) {
            self.selectionView.backgroundColor = self.selectedBgColor
            self.selectionView.selectSelectionType(selectionType: self.selectionType)
            self.initialDate(date: self.intialDate)
            self.calendarView.backgroundColor = self.bgColor
        }
    }
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        days = ModelDate.getDays(years, months)
        let configuration = CollectionViewConfiguration(layoutType: .fixedSize(sizeValue: 60, lineSpacing: 10), scrollingDirection: .horizontal)
        infiniteScrollingBehaviourForYears = InfiniteScrollingBehaviour(withCollectionView: yearRow, andData: years, delegate: self, configuration: configuration)
        infiniteScrollingBehaviourForMonths = InfiniteScrollingBehaviour(withCollectionView: monthRow, andData: months, delegate: self, configuration: configuration)
        infiniteScrollingBehaviourForDays = InfiniteScrollingBehaviour(withCollectionView: dateRow, andData: days, delegate: self, configuration: configuration)
    }
   
    // MARK: initial Date.
    func initialDate(date: Date) {
        let (mm, dd, yyyy) = date.seprateDateInDDMMYY
        let year = years.firstIndex { (modelObj) -> Bool in
            return modelObj.type == yyyy
        }
        let day = days.firstIndex { (modelObj) -> Bool in
            return Int(modelObj.type) == Int(dd)
        }
        guard let day = day else {
            return
        }
        guard let year = year else {
            return
        }
        let month = Int(mm)! - 1
        years[year].isSelected = true
        months[month].isSelected = true
        days[day].isSelected = true
        collectionState(infiniteScrollingBehaviourForYears, year)
        collectionState(infiniteScrollingBehaviourForMonths, month)
        collectionState(infiniteScrollingBehaviourForDays, day)
    }
    private func collectionState(_ collectionView: InfiniteScrollingBehaviour, _ index: Int) {
        let indexPathForFirstRow = IndexPath(row: index, section: 0)
        switch collectionView.collectionView.tag {
        case 0:
            self.days[indexPathForFirstRow.row].isSelected = true
            infiniteScrollingBehaviourForDays.reload(withData: days)
            break
        case 1:
            self.months[indexPathForFirstRow.row].isSelected = true
            infiniteScrollingBehaviourForMonths.reload(withData: months)
            break
        case 2:
            self.years[indexPathForFirstRow.row].isSelected = true
            infiniteScrollingBehaviourForYears.reload(withData: years)
            break
        default:
            break
        }
        collectionView.scroll(toElementAtIndex: index)
    }
}

extension FPTDatePicker: UICollectionViewDelegate {
    public func didEndScrolling(inInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) {
        selectMiddleRow(collectionView: behaviour.collectionView, data: behaviour.dataSetWithBoundary as! [ModelDate])
        switch behaviour.collectionView.tag {
        case 0:
            behaviour.reload(withData: days)
        case 1:
            behaviour.reload(withData: months)
            break
        case 2:
            behaviour.reload(withData: years)
        default:
            break
        }
        let date = CalendarHelper.getThatDate(days, months, years)
        delegate?.FPTDatePicker(didChange: date)
    }
    func selectMiddleRow(collectionView: UICollectionView, data: [ModelDate]) {
        let row = calculateMedian(array: collectionView.indexPathsForVisibleItems)
        let selectedIndexPath = IndexPath(row: Int(row), section: 0)
        for index in 0..<data.count where index != selectedIndexPath.row {
            data[index].isSelected = false
        }
        if let cell = collectionView.cellForItem(at: selectedIndexPath) as? DatePickerCollectionViewCell {
            cell.selectedCell(textColor: self.selectedTextColor)
            data[Int(row)].isSelected = true
            if collectionView.tag != 0 {
                compareDays()
            }
        }
        collectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
    }
}

extension FPTDatePicker {
    private func compareDays() {
        let newDays = ModelDate.getDays(years, months)
        if let selectedDay = days.filter({ (modelObject) -> Bool in
            return modelObject.isSelected
        }).first {
            newDays.selectDay(selectedDay: selectedDay)
        }
        days = newDays
        if Int(currentDay)! > days.count {
            let index = days.count - 1
            days[index].isSelected = true
            currentDay = "\(days.count)"
        }
    }
}

extension FPTDatePicker: InfiniteScrollingBehaviourDelegate {
    
    public func configuredCell(collectionView: UICollectionView,
                               forItemAtIndexPath indexPath: IndexPath, originalIndex: Int,
                               andData data: InfiniteScollingData,
                               forInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) -> UICollectionViewCell {
        let cell = behaviour.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DatePickerCollectionViewCell
        cell.labelDate.font = fontFamily
        switch behaviour.collectionView.tag {
        case 0:
            if let day = data as? ModelDate {
                //print(day)
                if day.isSelected {
                    cell.selectedCell(textColor: selectedTextColor)
                } else {
                    cell.deSelectCell(bgColor: deselectedBgColor, textColor: deselectTextColor)
                }
                cell.labelDate.text = day.type
            }
        case 1:
            if let month = data as? ModelDate {
                cell.labelDate.text = month.type
                if month.isSelected {
                    cell.selectedCell(textColor: selectedTextColor)
                } else {
                    cell.deSelectCell(bgColor: deselectedBgColor, textColor: deselectTextColor)
                }
            }
        case 2:
            if let year = data as? ModelDate {
                cell.labelDate.text = year.type
                if year.isSelected {
                    cell.selectedCell(textColor: selectedTextColor)
                } else {
                    cell.deSelectCell(bgColor: deselectedBgColor, textColor: deselectTextColor)
                }
            }
        default:
            return cell
        }
        return cell
    }
    public func didSelectItem(collectionView: UICollectionView, atIndexPath indexPath: IndexPath,
                              originalIndex: Int, andData data: InfiniteScollingData,
                              inInfiniteScrollingBehaviour behaviour: InfiniteScrollingBehaviour) {
        if let cell = behaviour.collectionView.cellForItem(at: indexPath) as? DatePickerCollectionViewCell {
            cell.labelDate.font = fontFamily
            if behaviour.collectionView.tag == 0 {
                for index in 0..<days.count where index != originalIndex {
                    currentDay = days[index].type
                    days[index].isSelected = false
                }
                days[originalIndex].isSelected = true
                compareDays()
                cell.selectedCell(textColor: selectedTextColor)
            } else if behaviour.collectionView.tag == 1 {
                for index in 0..<months.count where index != originalIndex {
                    months[index].isSelected = false
                }
                months[originalIndex].isSelected = true
                cell.selectedCell(textColor: selectedTextColor)
                compareDays()
                infiniteScrollingBehaviourForMonths.reload(withData: months)
            } else {
                for index in 0..<years.count where index != originalIndex {
                        years[index].isSelected = false
                }
                years[originalIndex].isSelected = true
                cell.selectedCell(textColor: selectedTextColor)
                compareDays()
                infiniteScrollingBehaviourForYears.reload(withData: years)
            }
        }
        let date = CalendarHelper.getThatDate(days, months, years)
        delegate?.FPTDatePicker(didChange: date)
        behaviour.scroll(toElementAtIndex: originalIndex)
    }
}

extension FPTDatePicker {
    public func yearRange(inBetween start: Int, end: Int) {
        years = ModelDate.getYears(startYear: start, endYear: end)
        infiniteScrollingBehaviourForYears.reload(withData: years)
        // yearRow.reloadData()
    }
    public func getSelectedDate() -> Date {
        let date = CalendarHelper.getThatDate(days, months, years)
        return date
    }
}

extension FPTDatePicker {
    func delay(_ seconds: Double, completion: @escaping () -> Void ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    func calculateMedian(array: [IndexPath]) -> Float {
        let sorted = array.sorted()
        if sorted.count % 2 == 0 {
            return Float((sorted[(sorted.count / 2)].row + sorted[(sorted.count / 2) - 1].row)) / 2
        } else {
            return Float(sorted[(sorted.count - 1) / 2].row)
        }
    }
}
