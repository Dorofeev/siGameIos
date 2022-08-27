//
//  Loading.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 27.08.2022.
//

import UIKit

class Loading: UIView {

    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    
    private lazy var gameLoadingLabel: UILabel = {
        let label = UILabel()
        
        label.font = R.font.futuraCondensed(size: 30)
        label.textColor = .white
        label.text = R.string.localizable.gameLoading()
        return label
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview != nil {
            setupLayout()
            activityIndicator.startAnimating()
        }
    }

    
    private func setupLayout() {
        self.addSubviews([activityIndicator, gameLoadingLabel], activateConstraints: [
            activityIndicator.topAnchor.constraint(equalTo: self.topAnchor),
            gameLoadingLabel.topAnchor.constraint(equalTo: activityIndicator.topAnchor),
            gameLoadingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            gameLoadingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gameLoadingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
