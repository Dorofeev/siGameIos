//
//  ProgressBar.swift
//  SIOnline
//
//  Created by Anna Kuptsova on 23.07.2022.
//

import UIKit

class ProgressBar: UILoadableView {
    @IBOutlet private var widthConstraint: NSLayoutConstraint!
    
    func setup(value: CGFloat, valueChangeDuration: CGFloat) {
        widthConstraint.constant = frame.width * value
        UIView.animate(withDuration: valueChangeDuration) {
            self.widthConstraint.constant = self.frame.width
            self.layoutIfNeeded()
        }
    }
}
