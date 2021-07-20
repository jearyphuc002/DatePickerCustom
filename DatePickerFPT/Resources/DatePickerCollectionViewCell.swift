//
//  DatePickerCollectionViewCell.swift
//  DatePickerFPT
//
//  Created by Nguyen Thanh Phuc on 6/19/21.
//

import UIKit

class DatePickerCollectionViewCell: UICollectionViewCell {
////
    @IBOutlet weak var labelDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let bottomBorder: UIView = UIView(frame:
        CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1))
        bottomBorder.backgroundColor = .white
        self.contentView.addSubview(bottomBorder)
    }
}

extension DatePickerCollectionViewCell {
    func selectedCell(textColor: UIColor) {
        self.backgroundColor = .clear
        self.labelDate.textColor = textColor
        self.alpha = 1
    }
    func deSelectCell(bgColor: UIColor, textColor: UIColor) {
        self.backgroundColor = bgColor
        self.labelDate.textColor = textColor
        self.alpha = 0.5
    }
}
