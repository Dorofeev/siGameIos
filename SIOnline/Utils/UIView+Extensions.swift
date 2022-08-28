//
//  UIView+Extensions.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 17.08.2022.
//

import UIKit

extension UIView {
  
    func addSubview(_ view: UIView, activateConstraints: [NSLayoutConstraint]) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate(activateConstraints)
    }
    
    func addSubviews(_ views: [UIView], activateConstraints: [NSLayoutConstraint]) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        NSLayoutConstraint.activate(activateConstraints)
    }
    
    func addSubview(_ view: UIView, layout: @escaping(UIView, UIView)->([NSLayoutConstraint])) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate(layout(self, view))
    }
    
    func addEnclosedSubview(_ view: UIView, insets: NSDirectionalEdgeInsets = .zero) {
        addSubview(view, activateConstraints: [
            view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: insets.top),
            view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom),
            view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: insets.leading),
            view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -insets.trailing),
        ])
    }
}
