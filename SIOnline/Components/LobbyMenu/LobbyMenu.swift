//
//  LobbyMenu.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 07.09.2022.
//

import UIKit
import ReSwift

class LobbyMenu: UIView {
    
    // MARK: - Properties
    
    private var dispatch: DispatchFunction?
    
    // MARK: - Views
    
    private lazy var flyoutButton: FlyoutButton = {
        let button = FlyoutButton()
        button.setup(title: "☰")
        button.button.titleLabel?.font = R.font.futuraCondensed(size: 26)
        button.setup(flyout: innerView)
        return button
    }()
    
    private var innerView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private var gamesButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = R.font.futuraCondensed(size: 26)
        button.setTitle(R.string.localizable.games(), for: .normal)
        return button
    }()
    
    private var chatButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = R.font.futuraCondensed(size: 26)
        button.setTitle(R.string.localizable.chat(), for: .normal)
        return button
    }()
    
    private var settingsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = R.font.futuraCondensed(size: 26)
        button.setTitle(R.string.localizable.settings(), for: .normal)
        return button
    }()
    
    private var aboutButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = R.font.futuraCondensed(size: 26)
        button.setTitle(R.string.localizable.aboutTitle(), for: .normal)
        return button
    }()
    
    private var exitButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = R.font.futuraCondensed(size: 26)
        button.setTitle(R.string.localizable.exit(), for: .normal)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    // MARK: - Setup
    
    func setup(dispatch: @escaping DispatchFunction) {
        self.dispatch = dispatch
    }
    
    private func setupLayout() {
        self.addEnclosedSubview(flyoutButton)
        innerView.addArrangedSubview(gamesButton)
        innerView.addArrangedSubview(chatButton)
        innerView.addArrangedSubview(settingsButton)
        innerView.addArrangedSubview(aboutButton)
        innerView.addArrangedSubview(exitButton)
    }
    
    private func setupAction() {
        let gamesAction = UIAction { [weak self] _ in
            self?.dispatch?(ActionCreators.shared.onOnlineModeChanged(mode: .games))
        }
        gamesButton.addAction(gamesAction, for: .touchUpInside)
        
        let chatAction = UIAction { [weak self] _ in
            self?.dispatch?(ActionCreators.shared.onOnlineModeChanged(mode: .chat))
        }
        chatButton.addAction(chatAction, for: .touchUpInside)
        
        let settingsAction = UIAction { [weak self] _ in
            self?.dispatch?(ActionCreators.shared.showSettings(show: true))
        }
        settingsButton.addAction(settingsAction, for: .touchUpInside)
        
        let aboutAction = UIAction { [weak self] _ in
            self?.dispatch?(ActionCreators.shared.navigateToHowToPlay())
        }
        aboutButton.addAction(aboutAction, for: .touchUpInside)
        
        let exitAction = UIAction { [weak self] _ in
            guard let dataContext = Index.dataContext else { return }
            self?.dispatch?(ActionCreators.shared.onExit(dataContext: dataContext))
        }
        exitButton.addAction(exitAction, for: .touchUpInside)
    }
}
