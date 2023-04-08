//
//  RulesCollectionViewCell.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 13.01.2023.
//

import UIKit

class RulesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 24)
        label.textColor = .white
        
        return label
    }()
    
    // MARK: - Setup
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            setup()
        }
    }
    
    private func setup() {
        contentView.backgroundColor = .white.withAlphaComponent(0.15)
        contentView.addEnclosedSubview(
            titleLabel,
            insets: NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        )
    }
    
    func fill(title: String) {
        titleLabel.text = title
    }
}
