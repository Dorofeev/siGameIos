//
//  SIStorageSelectorCell.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 24.08.2023.
//

import UIKit

struct SIStorageSelectorOption {
    let key: String
    let title: String
}

class SIStorageSelectorCell: UITableViewCell {
    
    static let reusableIdentifier = "SIStorageSelectorCell"
    
    struct DatalModel {
        let selectorName: String
        let selectedValue: SIStorageSelectorOption
        let options: [SIStorageSelectorOption]
    }
    
    private var selectedValue: SIStorageSelectorOption?
    private var options: [SIStorageSelectorOption] = []
    private var onSelected: ((SIStorageSelectorOption) -> Void)?
    
    private lazy var selectorNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.placeholderColor()
        label.font = R.font.clefs(size: 18)
        return label
    }()
    
    private lazy var selectorBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.inputBackground()
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var selectorValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.font = R.font.clefs(size: 16)
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.arrowDown()
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.backgroundView?.backgroundColor = .clear
        self.selectionStyle = .none
        setupLayout()
        
        selectorBackgroundView.isUserInteractionEnabled = true
        selectorBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showSelector)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(model: DatalModel, onSelected: @escaping (SIStorageSelectorOption) -> Void) {
        selectorNameLabel.text = model.selectorName
        self.selectorValueLabel.text = model.selectedValue.title
        self.selectedValue = model.selectedValue
        self.options = model.options
        self.onSelected = onSelected
    }
    
    private func setupLayout() {
        contentView.addEnclosedSubview(selectorBackgroundView, insets: NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        
        selectorBackgroundView.addSubviews([selectorNameLabel, selectorValueLabel, arrowImageView], activateConstraints: [
            selectorNameLabel.topAnchor.constraint(equalTo: selectorBackgroundView.topAnchor, constant: 8),
            selectorNameLabel.leadingAnchor.constraint(equalTo: selectorBackgroundView.leadingAnchor, constant: 16),
            selectorNameLabel.trailingAnchor.constraint(equalTo: selectorBackgroundView.trailingAnchor, constant: -16),
            
            selectorValueLabel.bottomAnchor.constraint(equalTo: selectorBackgroundView.bottomAnchor, constant: -8),
            selectorValueLabel.leadingAnchor.constraint(equalTo: selectorBackgroundView.leadingAnchor, constant: 16),
            selectorValueLabel.trailingAnchor.constraint(equalTo: selectorBackgroundView.trailingAnchor, constant: -16),
            selectorValueLabel.topAnchor.constraint(equalTo: selectorNameLabel.bottomAnchor, constant: 8),
            
            arrowImageView.centerYAnchor.constraint(equalTo: selectorBackgroundView.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: selectorBackgroundView.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func showSelector() {
        let alert = UIAlertController(title: self.selectorNameLabel.text, message: nil, preferredStyle: .actionSheet)
        
        for option in options {
            alert.addAction(UIAlertAction(title: option.title, style: .default, handler: { [weak self] _ in
                self?.selectorValueLabel.text = option.title
                self?.onSelected?(option)
            }))
        }
        alert.addAction(UIAlertAction(title: R.string.localizable.close(), style: .cancel))
        self.window?.rootViewController?.presentedViewController?.present(alert, animated: true)
    }
}
