//
//  UIView+.swift
//  Exercise
//

import Foundation
import UIKit

extension UIView {
    func roundCornerWithHeight(borderColor: UIColor = UIColor("5CC971")) {
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
        layer.cornerCurve = .continuous
        layer.borderWidth = 1.5
        layer.borderColor = borderColor.cgColor

    }
}
