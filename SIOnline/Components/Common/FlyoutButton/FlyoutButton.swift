//
//  FlyoutButton.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 03.09.2022.
//

import UIKit

class FlyoutButton: UIView {
    
    struct FlyoutButtonState {
        var isOpen: Bool
    }
    
    // MARK: - Properties
    
    private var state = FlyoutButtonState(isOpen: false)
    
    // MARK: - Views
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.tintColor = R.color.buttonTint()
        button.backgroundColor = .clear
        button.titleLabel?.font = R.font.futuraCondensed(size: 17)
        return button
    }()
    
    private lazy var flyoutView: UIView = {
       let view = UIView()
        return view
    }()
    
    // MARK: - Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
        initialSetup()
    }
    
    func setup(title: String) {
        button.setTitle(title, for: .normal)
    }
    
    func setup(isEnabled: Bool) {
        button.isEnabled = isEnabled
    }
    
    func setup(flyout: UIView) {
        flyoutView.addEnclosedSubview(flyout)
    }
    
    private func setupLayout() {
        addEnclosedSubview(button, insets: NSDirectionalEdgeInsets(top: 5, leading: 7, bottom: 6, trailing: 10))
    }
    
    private func initialSetup() {
        let action = UIAction { [weak self] _ in
            self?.onClick()
        }
        button.addAction(action, for: .touchUpInside)
    }
    
    private func hideFlyout() {
        flyoutView.removeFromSuperview()
        state.isOpen = false
    }
    
    private func showFlyout() {
        guard let window = self.window else { return }
        let windowFrame = button.convert(frame, to: window)
        
        window.addSubview(flyoutView, activateConstraints: [
            flyoutView.topAnchor.constraint(equalTo: window.topAnchor, constant: windowFrame.maxY),
            flyoutView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 10),
            flyoutView.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -10),
        ])
        state.isOpen = true
    }
    
    private func onClick() {
        if state.isOpen {
            hideFlyout()
        } else {
            showFlyout()
        }
    }
}
