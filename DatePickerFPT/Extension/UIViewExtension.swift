//
//  UIViewExtension.swift
//  DatePickerFPT
//
//  Created by Nguyen Thanh Phuc on 6/19/21.
//

import UIKit

extension UIView {
    func selectSelectionType(selectionType: SelectionType) {
        switch selectionType {
        case .square:
            self.layer.cornerRadius = 0.0
        case .roundedsquare:
            self.layer.cornerRadius = 5.0
        case .circle:
            self.layer.cornerRadius = self.frame.size.width / 2
        }
    }
}
