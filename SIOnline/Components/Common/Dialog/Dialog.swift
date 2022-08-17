//
//  Dialog.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 14.08.2022.
//

import UIKit

class Dialog: Body {
    
    // MARK: - Properties
    
    private var onClose: (() -> Void)?
    
    // MARK: - Views
    
    private var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.clefs(size: 14.0)
        label.textColor = .white
        label.h1()
        label.numberOfLines = 0
        return label
    }()
    
    private var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.close()!, for: .normal)
        return button
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            initialSetup()
        }
    }
    
    // MARK: - Setup
    
    func setup(title: String, children: [UIView], onClose: @escaping () -> Void) {
        self.onClose = onClose
        titleLabel.text = title
        children.forEach { contentStackView.addArrangedSubview($0) }
    }
    
    // MARK: - Private funcs
    
    private func initialSetup() {
        closeButton.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.onClose?()
                }
            ), for: .touchUpInside
        )
        
        addEnclosedSubview(contentStackView)
        
        let titleView = UIView()
        contentStackView.addArrangedSubview(titleView)
        
        titleView.addSubviews([titleLabel, closeButton], activateConstraints: [
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 13),
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -10),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -10),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor)
        ])
    }
    
}
