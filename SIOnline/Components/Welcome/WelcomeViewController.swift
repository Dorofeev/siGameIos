//
//  WelcomeViewController.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 03.09.2022.
//

import UIKit
import ReSwift

class WelcomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var dispatch: DispatchFunction?
    
    // MARK: - Views
    
    private lazy var serverStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var serverLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.futuraCondensed(size: 24)
        label.text = "\(R.string.localizable.server()): \(R.string.localizable.appUser())"
        return label
    }()
    
    private lazy var serverLicenseDescription = UILabel()
    
    private lazy var serverLicenseButton: FlyoutButton = {

        let button = FlyoutButton()
        button.setup(title: "ⓘ")
        
        let innerView = UIView()
        innerView.backgroundColor = R.color.flyoutBackground()
        
        let titleLabel = UILabel()
        titleLabel.text = R.string.localizable.serverLicense()
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        innerView.addSubviews([titleLabel, serverLicenseDescription], activateConstraints: [
            titleLabel.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: innerView.topAnchor, constant: 10),
            
            serverLicenseDescription.leadingAnchor.constraint(
                equalTo: innerView.leadingAnchor,
                constant: 10
            ),
            serverLicenseDescription.trailingAnchor.constraint(
                equalTo: innerView.trailingAnchor,
                constant: 10
            ),
            serverLicenseDescription.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 5
            ),
            serverLicenseDescription.bottomAnchor.constraint(
                equalTo: innerView.bottomAnchor,
                constant: -10
            ),
        ])
        
        button.setup(flyout: innerView)
        return button
    }()
    
    private lazy var welcomeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.futuraCondensed(size: 24)
        label.text = R.string.localizable.welcomeTitle()
        return label
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var singlePlayButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = R.font.futuraCondensed(size: 30)
        button.backgroundColor = R.color.standartButtonBackground()
        button.setTitle(R.string.localizable.singlePlay(), for: .normal)
        return button
    }()
    
    private lazy var friendsPlayButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = R.font.futuraCondensed(size: 30)
        button.backgroundColor = R.color.standartButtonBackground()
        button.setTitle(R.string.localizable.friendsPlay(), for: .normal)
        return button
    }()
    
    private lazy var anyonePlayButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = R.font.futuraCondensed(size: 30)
        button.backgroundColor = R.color.standartButtonBackground()
        button.setTitle(R.string.localizable.anyonePlay(), for: .normal)
        return button
    }()
    
    private lazy var joinLobbyButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = R.font.futuraCondensed(size: 30)
        button.backgroundColor = R.color.standartButtonBackground()
        button.setTitle(R.string.localizable.joinLobby(), for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = R.color.backgroundColor()
        setupLayout()
        setupActions()
    }
    
    // MARK: - Setup
    
    func setup(state: State) {
        let serverName = state.common.serverName ?? R.string.localizable.appUser()
        serverLabel.text = "\(R.string.localizable.server()): \(serverName)"
        
        serverLicenseDescription.text = state.common.serverLicense
        
        singlePlayButton.isEnabled = state.common.isConnected
    }
    
    func setup(dispatch: @escaping DispatchFunction) {
        self.dispatch = dispatch
    }
    
    private func setupLayout() {
        serverStackView.addArrangedSubview(serverLabel)
        serverStackView.addArrangedSubview(serverLicenseButton)
        
        view.addSubview(serverStackView, activateConstraints: [
            serverStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 10
            ),
            serverStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(welcomeTitleLabel, activateConstraints: [
            welcomeTitleLabel.topAnchor.constraint(
                equalTo: serverStackView.bottomAnchor,
                constant: 10
            ),
            welcomeTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        
        buttonsStackView.addArrangedSubview(singlePlayButton)
        buttonsStackView.addArrangedSubview(friendsPlayButton)
        buttonsStackView.addArrangedSubview(anyonePlayButton)
        buttonsStackView.addArrangedSubview(joinLobbyButton)
        
        view.addSubview(buttonsStackView, activateConstraints: [
            buttonsStackView.topAnchor.constraint(
                equalTo: welcomeTitleLabel.bottomAnchor,
                constant: 10
            ),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            buttonsStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -10
            )
        ])
    }
    
    private func setupActions() {
        let singlePlayAction = UIAction { [weak self] _ in
            self?.dispatch?(ActionCreators.shared.singlePlay())
        }
        singlePlayButton.addAction(singlePlayAction, for: .touchUpInside)
        
        let friendsPlayAction = UIAction { [weak self] _ in
            guard let dataContext = Index.dataContext else { return }
            self?.dispatch?(ActionCreators.shared.friendsPlay(dataContext: dataContext))
        }
        friendsPlayButton.addAction(friendsPlayAction, for: .touchUpInside)
        
        let anyonePlayAction = UIAction { [weak self] _ in
            guard let dataContext = Index.dataContext else { return }
            self?.dispatch?(ActionCreators.shared.createNewAutoGame(dataContext: dataContext))
        }
        anyonePlayButton.addAction(anyonePlayAction, for: .touchUpInside)
        
        let joinLobbyAction = UIAction { [weak self] _ in
            guard let dataContext = Index.dataContext else { return }
            self?.dispatch?(ActionCreators.shared.navigateToLobby(
                dataContext: dataContext,
                gameId: -1,
                showInfo: nil
            ))
        }
        joinLobbyButton.addAction(joinLobbyAction, for: .touchUpInside)
    }
}
