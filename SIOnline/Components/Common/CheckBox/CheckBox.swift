//
//  CheckBox.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 05.09.2022.
//

import UIKit

class CheckBox: UIView {
    
    private lazy var checkmarkLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
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
    
    private func initialSetup() {
        self.backgroundColor = .clear
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

}
