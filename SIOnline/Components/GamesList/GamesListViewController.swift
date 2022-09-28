//
//  GamesListViewController.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 08.09.2022.
//

import UIKit
import ReSwift

class GamesListViewController: UIViewController {
    
    // MARK: - Properties
    
    private var dispatch: DispatchFunction?
    
    private var games: [GameInfo] = []
    
    private var showInfo: Bool = false
    
    // MARK: - Views
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var lobbyButton = LobbyMenu()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 26)
        label.textColor = .white
        return label
    }()
    
    private lazy var gamesFilterButton: FlyoutButton = {
        let button = FlyoutButton()
        button.button.titleLabel?.font = R.font.futuraCondensed(size: 26)
        button.setup(flyout: gamesFilterStackView)
        return button
    }()
    
    private lazy var gamesFilterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.addArrangedSubview(newCheckBox)
        stackView.addArrangedSubview(sportCheckBox)
        stackView.addArrangedSubview(tvCheckBox)
        stackView.addArrangedSubview(withoutPasswordCheckBox)
        return stackView
    }()
    
    private lazy var newCheckBox: CheckBox = {
        let checkBox = CheckBox()
        checkBox.setup(header: R.string.localizable.new())
        return checkBox
    }()
    
    private lazy var sportCheckBox: CheckBox = {
        let checkBox = CheckBox()
        checkBox.setup(header: R.string.localizable.sportPlural())
        return checkBox
    }()
    
    private lazy var tvCheckBox: CheckBox = {
        let checkBox = CheckBox()
        checkBox.setup(header: R.string.localizable.tvPlural())
        return checkBox
    }()
    
    private lazy var withoutPasswordCheckBox: CheckBox = {
        let checkBox = CheckBox()
        checkBox.setup(header: R.string.localizable.withoutPassword())
        return checkBox
    }()
    
    private lazy var gamesSearchTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 17)
        textField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.searchGames(),
            attributes: [.foregroundColor: R.color.placeholderColor()]
        )
        textField.backgroundColor = R.color.inputBackground()
        textField.autocorrectionType = .no
        
        textField.placeholder = R.string.localizable.searchGames()
        return textField
    }()
    
    private lazy var gamesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            GameTableViewCell.self,
            forCellReuseIdentifier: GameTableViewCell.reusableIdentifier
        )
        return tableView
    }()
    
    private lazy var loadErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.darkRed()
        label.backgroundColor = R.color.errorBackground()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var commandButtonsPanel: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.backgroundColor()
        setupLayout()
        setupActions()
        setup(games: [GameInfo(
            gameID: 0,
            gameName: "Test game",
            language: "",
            mode: .Classic,
            owner: "",
            packageName: "",
            passwordRequired: true,
            persons: [],
            realStartTime: "",
            rules: 0,
            stage: 0,
            stageName: "",
            started: false,
            startTime: ""
        )], showInfo: false)
        setup(state: State.initialState())
    }
    
    // MARK: - Setup
    
    func setup(games: [GameInfo], showInfo: Bool) {
        titleLabel.text = R.string.localizable.games() + " (\(games.count))"
        self.games = games
        self.showInfo = showInfo
        gamesTableView.reloadData()
    }
    
    func setup(dispatch: @escaping DispatchFunction) {
        self.dispatch = dispatch
    }
    
    func setup(state: State) {
        newCheckBox.setup(isChecked: state.online.gamesFilter & GamesFilter.new.rawValue > 0)
        newCheckBox.setup(isEnabled: state.common.isConnected)
        
        sportCheckBox.setup(isChecked: state.online.gamesFilter & GamesFilter.sport.rawValue > 0)
        sportCheckBox.setup(isEnabled: state.common.isConnected)
        
        tvCheckBox.setup(isChecked: state.online.gamesFilter & GamesFilter.tv.rawValue > 0)
        tvCheckBox.setup(isEnabled: state.common.isConnected)
        
        withoutPasswordCheckBox.setup(
            isChecked: state.online.gamesFilter & GamesFilter.noPassword.rawValue > 0
        )
        withoutPasswordCheckBox.setup(isEnabled: state.common.isConnected)
        
        let filterValue = GamesFilter.getFilterValue(gameFilter: state.online.gamesFilter)
        
        gamesFilterButton.setup(title: filterValue + " ▾")
        
        gamesSearchTextField.text = state.online.gamesSearch
        
        gamesTableView.isHidden = !state.online.error.isEmpty
        loadErrorLabel.isHidden = state.online.error.isEmpty
        loadErrorLabel.text = state.online.error
    }
    
    private func setupLayout() {
        view.addSubview(titleStackView, activateConstraints: [
            titleStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleStackView.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        titleStackView.addArrangedSubview(lobbyButton)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(UIView())
        titleStackView.addArrangedSubview(gamesFilterButton)
        
        view.addSubview(gamesSearchTextField, activateConstraints: [
            gamesSearchTextField.topAnchor.constraint(
                equalTo: titleStackView.bottomAnchor,
                constant: 4
            ),
            gamesSearchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            gamesSearchTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -10
            ),
            gamesSearchTextField.heightAnchor.constraint(equalToConstant: 47)
        ])
        
        view.addSubview(gamesTableView, activateConstraints: [
            gamesTableView.topAnchor.constraint(
                equalTo: gamesSearchTextField.bottomAnchor,
                constant: 8
            ),
            gamesTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 10
            ),
            gamesTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -10
            ),
            gamesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        view.addSubview(loadErrorLabel, activateConstraints: [
            loadErrorLabel.topAnchor.constraint(
                equalTo: gamesSearchTextField.bottomAnchor,
                constant: 8
            ),
            loadErrorLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 10
            ),
            loadErrorLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -10
            ),
            loadErrorLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        view.addSubview(commandButtonsPanel, activateConstraints: [
            commandButtonsPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            commandButtonsPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            commandButtonsPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupActions() {
        newCheckBox.setup { [weak self] in
            self?.dispatch?(ActionCreators.shared.onGamesFilterToggle(filter: GamesFilter.new))
        }
        
        sportCheckBox.setup { [weak self] in
            self?.dispatch?(ActionCreators.shared.onGamesFilterToggle(filter: GamesFilter.sport))
        }
        
        tvCheckBox.setup { [weak self] in
            self?.dispatch?(ActionCreators.shared.onGamesFilterToggle(filter: GamesFilter.tv))
        }
        
        withoutPasswordCheckBox.setup { [weak self] in
            self?.dispatch?(ActionCreators.shared.onGamesFilterToggle(filter: GamesFilter.noPassword))
        }
        
        gamesSearchTextField.addAction(UIAction(handler: { [weak self] _ in
            guard let text = self?.gamesSearchTextField.text else { return }
            self?.dispatch?(ActionCreators.shared.onGamesSearchChanged(search: text))
        }), for: .editingChanged)
    }
}

extension GamesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GameTableViewCell.reusableIdentifier,
            for: indexPath
        ) as? GameTableViewCell else {
            fatalError("incorrect cell type")
        }
        cell.fill(games[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = games[indexPath.row]
        dispatch?(ActionCreators.shared.selectGame(gameId: game.gameID, showInfo: showInfo))
    }
}
