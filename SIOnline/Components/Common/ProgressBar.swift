//
//  ProgressBar.swift
//  SIOnline
//
//  Created by Anna Kuptsova on 23.07.2022.
//

import UIKit

class ProgressBar: UIView {
    @IBOutlet private var widthConstraint: NSLayoutConstraint!
    
    func setup(value: CGFloat) {
        widthConstraint.constant = value
    }
}
