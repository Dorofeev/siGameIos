//
//  ProgressBar.swift
//  SIOnline
//
//  Created by Anna Kuptsova on 23.07.2022.
//

import UIKit

class ProgressBar: UILoadableView {
    @IBOutlet private var widthConstraint: NSLayoutConstraint!
    @IBOutlet private var leadingConstraint: NSLayoutConstraint!
    
    @IBOutlet private var fullView: UIView!
    
    func setup(value: CGFloat, valueChangeDuration: CGFloat) {
        widthConstraint.constant = frame.width * value
        UIView.animate(withDuration: valueChangeDuration) {
            self.widthConstraint.constant = self.frame.width
            self.layoutIfNeeded()
        }
    }
    
    func setupIndeterminate() {
        widthConstraint.constant = 50
        fullView.backgroundColor = .clear
        self.layoutIfNeeded()
        let gradient = CAGradientLayer()
        let mainColor = UIColor(red: 0.09375, green: 0.234, blue: 0.949, alpha: 1.0)
        gradient.colors = [UIColor.clear.cgColor, mainColor.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 0.5, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.frame = fullView.bounds
        
        self.fullView.layer.addSublayer(gradient)
        startRepeatableAnimation()
    }
    
    func startRepeatableAnimation() {
        leadingConstraint.constant = -50
        self.layoutIfNeeded()
        UIView.animate(withDuration: 3.0) { [weak self] in
            guard let self = self else { return }
            self.leadingConstraint.constant = UIScreen.main.bounds.width + 50
            self.layoutIfNeeded()
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.startRepeatableAnimation()
        }
    }
    
}
