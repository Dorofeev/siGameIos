//
//  LoginViewController.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 21.08.2022.
//

import ReSwift
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Actions
    
    private var dispatch: DispatchFunction?
    
    // MARK: - Views
    
    private lazy var progressBar: ProgressBar = {
        let view = ProgressBar()
        view.setupIndeterminate()
        view.isHidden = true
        return view
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.appName()
        label.font = R.font.futuraCondensed(size: 30)
        label.textColor = .white
        return label
    }()
    
    private lazy var yourNameLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.yourName()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var yourNameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.borderStyle = .none
        textField.backgroundColor = R.color.inputBackground()
        textField.layer.borderWidth = 1.0
        return textField
    }()
    
    private lazy var settingsHintLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.settingsHint()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.darkRed()
        return label
    }()
    
    private lazy var buttonsView = UIView()
    
    private lazy var howToPlayButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.backgroundColor = R.color.standartButtonBackground()
        button.setTitle(R.string.localizable.aboutTitle(), for: .normal)
        return button
    }()
    
    private lazy var enterButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.backgroundColor = R.color.standartButtonBackground()
        button.setTitle(R.string.localizable.enter(), for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = R.color.loginBackground()
        yourNameTextField.delegate = self
        setupLayout()
        setupActions()
    }
    
    func setup(dispatch: @escaping DispatchFunction) {
        self.dispatch = dispatch
    }
    
    func update(state: State) {
        progressBar.isHidden = !state.login.inProgress
        view.isUserInteractionEnabled = state.login.inProgress
        
        yourNameTextField.text = state.user.login
        
        errorLabel.text = state.login.errorMessage
        
        enterButton.isEnabled = !state.user.login.isEmpty
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        view.addSubview(progressBar, activateConstraints: [
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(headerLabel, activateConstraints: [
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22)
        ])
        
        view.addSubview(yourNameLabel, activateConstraints: [
            yourNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            yourNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            yourNameLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20)
        ])
        
        view.addSubview(yourNameTextField, activateConstraints: [
            yourNameTextField.heightAnchor.constraint(equalToConstant: 33),
            yourNameTextField.topAnchor.constraint(equalTo: yourNameLabel.bottomAnchor, constant: 10),
            yourNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            yourNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22)
        ])
        
        view.addSubview(settingsHintLabel, activateConstraints: [
            settingsHintLabel.topAnchor.constraint(equalTo: yourNameTextField.bottomAnchor, constant: 10),
            settingsHintLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            settingsHintLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
        ])
        
        view.addSubview(errorLabel, activateConstraints: [
            errorLabel.topAnchor.constraint(equalTo: settingsHintLabel.bottomAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
        ])
        
        view.addSubview(buttonsView, activateConstraints: [
            buttonsView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 50),
            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5)
        ])
        
        buttonsView.addSubviews([howToPlayButton, enterButton], activateConstraints: [
            howToPlayButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor),
            howToPlayButton.trailingAnchor.constraint(equalTo: enterButton.leadingAnchor, constant: -5),
            howToPlayButton.topAnchor.constraint(equalTo: buttonsView.topAnchor),
            howToPlayButton.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            enterButton.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor),
            enterButton.widthAnchor.constraint(equalTo: howToPlayButton.widthAnchor),
            enterButton.topAnchor.constraint(equalTo: buttonsView.topAnchor),
            enterButton.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            howToPlayButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func setupActions() {
        howToPlayButton.addAction(UIAction(handler: { [weak self] _ in
            self?.dispatch?(ActionCreators.shared.navigateToHowToPlay())
        }), for: .touchUpInside)
        
        enterButton.addAction(UIAction(handler: { [weak self] _ in
            guard let dataContext = Index.dataContext else { return }
            self?.dispatch?(ActionCreators.shared.login(dataContext: dataContext))
        }), for: .touchUpInside)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentValue = textField.text ?? ""
        let newValue = (currentValue as NSString).replacingCharacters(in: range, with: string)
        if newValue.count <= 30 {
            dispatch?(ActionCreators.shared.onLoginChanged(newLogin: newValue))
            return true
        } else {
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let dataContext = Index.dataContext else { return true }
        dispatch?(ActionCreators.shared.login(dataContext: dataContext))
        return true
    }
}
