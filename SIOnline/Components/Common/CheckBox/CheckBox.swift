//
//  CheckBox.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 05.09.2022.
//

import UIKit

class CheckBox: UIView {
    
    // MARK: - Properties
    
    private var onClick: (() -> Void)?
    
    // MARK: - Views
    
    private lazy var checkmarkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.futuraCondensed(size: 26)
        return label
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.futuraCondensed(size: 26)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
        setupLayout()
    }
    
    // MARK: - Setup
    
    func setup(header: String) {
        headerLabel.text = header
    }
    
    func setup(isChecked: Bool) {
        checkmarkLabel.text = isChecked ? "✔" : ""
    }
    
    func setup(onClick: @escaping () -> Void) {
        self.onClick = onClick
    }
    
    func setup(isEnabled: Bool) {
        self.isUserInteractionEnabled = isEnabled
        self.checkmarkLabel.textColor = isEnabled ? UIColor.white : UIColor.darkGray
        self.headerLabel.textColor = isEnabled ? UIColor.white : UIColor.darkGray
    }
    
    private func initialSetup() {
        self.backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickAction))
        self.addGestureRecognizer(tapGesture)
    }
    
    private func setupLayout() {
        self.addSubviews([checkmarkLabel, headerLabel], activateConstraints: [
            checkmarkLabel.topAnchor.constraint(equalTo: self.topAnchor),
            checkmarkLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            checkmarkLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            checkmarkLabel.widthAnchor.constraint(equalToConstant: 26),
            headerLabel.topAnchor.constraint(equalTo: self.topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 12),
            headerLabel.leadingAnchor.constraint(equalTo: checkmarkLabel.trailingAnchor, constant: 8),
        ])
    }
    
    @objc private func onClickAction() {
        onClick?()
    }
}
