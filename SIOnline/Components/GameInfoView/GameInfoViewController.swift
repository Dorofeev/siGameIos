//
//  GameInfoViewController.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 04.11.2022.
//

import AlignedCollectionViewFlowLayout
import ReSwift
import UIKit

class GameInfoViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var innerInfoView: UIStackView = createStackView(views: [], spacing: 16)
    
    private lazy var scrollStackView: UIStackView = createStackView(
        views: [
            hostStackView,
            questionPackageStackView,
            rulesStackView,
            showmanStackView,
            playersStackView,
            viewersStackView,
            statusStackView,
            createdStackView,
            startedStackView,
            passwordInfoStackView,
            joinGameErrorView
        ],
        spacing: 8
    )
    
    // MARK: - game name
    
    private lazy var gameNameContainer = UIView()
    private lazy var gameNameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 54)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .white
        return label
    }()
    
    // MARK: - game info
    
    private lazy var scrollView = UIScrollView()
    
    // MARK: - host
    
    private lazy var hostStackView: UIStackView = createStackView(views: [hostLabel, ownerLabel], spacing: 0)
    private lazy var hostLabel: UILabel = createTitleLabel(title: R.string.localizable.host())
    private lazy var ownerLabel: UILabel = createValueLabel()
    
    // MARK: - question package
    
    private lazy var questionPackageStackView: UIStackView = createStackView(views: [questionPackageLabel, packageNameLabel], spacing: 0)
    private lazy var questionPackageLabel: UILabel = createTitleLabel(title: R.string.localizable.questionPackage())
    private lazy var packageNameLabel: UILabel = createValueLabel()
    
    // MARK: - rules
    
    private lazy var rulesStackView: UIStackView = createStackView(views: [rulesLabel, rulesCollectionView], spacing: 4)
    private lazy var rulesLabel: UILabel = createTitleLabel(title: R.string.localizable.rules())
    private lazy var rulesCollectionView: UICollectionView = createCollectionView()
    
    // MARK: - Showman
    
    private lazy var showmanStackView: UIStackView = createStackView(views: [showmanLabel, showmanNameLabel], spacing: 0)
    private lazy var showmanLabel: UILabel = createTitleLabel(title: R.string.localizable.showman())
    private lazy var showmanNameLabel: UILabel = createValueLabel()
    
    // MARK: - Players
    
    private lazy var playersStackView: UIStackView = createStackView(views: [playersLabel, playersCollectionView], spacing: 4)
    private lazy var playersLabel: UILabel = createTitleLabel(title: R.string.localizable.players())
    private lazy var playersCollectionView: UICollectionView = createCollectionView()
    
    // MARK: - Viewers
    
    private lazy var viewersStackView: UIStackView = createStackView(views: [viewersLabel, viewersCollectionView], spacing: 4)
    private lazy var viewersLabel: UILabel = createTitleLabel(title: R.string.localizable.viewers())
    private lazy var viewersCollectionView: UICollectionView = createCollectionView()
    
    // MARK: - Status
    
    private lazy var statusStackView: UIStackView = createStackView(views: [statusLabel, stageLabel], spacing: 0)
    private lazy var statusLabel: UILabel = createTitleLabel(title: R.string.localizable.status())
    private lazy var stageLabel: UILabel = createValueLabel()
    // MARK: - Created
    
    private lazy var createdStackView: UIStackView = createStackView(views: [createdLabel, createdTimeLabel], spacing: 0)
    private lazy var createdLabel: UILabel = createTitleLabel(title: R.string.localizable.created())
    private lazy var createdTimeLabel: UILabel = createValueLabel()
    
    // MARK: - Started
    
    private lazy var startedStackView: UIStackView = createStackView(views: [startedLabel, startedTimeLabel], spacing: 0)
    private lazy var startedLabel: UILabel = createTitleLabel(title: R.string.localizable.started())
    private lazy var startedTimeLabel: UILabel = createValueLabel()
    
    // MARK: - Password Info
    
    private lazy var passwordInfoStackView: UIStackView =  {
        let stackView = createStackView(views: [passwordLabel, passwordInput], spacing: 0)
        passwordInput.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20).isActive = true
        return stackView
    }()
    
    private lazy var passwordLabel: UILabel = createTitleLabel(title: R.string.localizable.password())
    
    private lazy var passwordInput: Input = {
        let input = Input()
        input.font = R.font.futuraCondensed(size: 21)
        input.isSecureTextEntry = true
        return input
    }()
    
    // MARK: - Join Game Error
    
    private lazy var joinGameErrorLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 21)
        label.textColor = .red
        return label
    }()
    
    private lazy var joinGameErrorView: UIView = {
        let view = UIView()
        view.addEnclosedSubview(joinGameErrorLabel, insets: NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        return view
    }()
    
    // MARK: - Buttons
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = createStackView(views: [joinAsShowmanButton, joinAsPlayerButton, joinAsViewerButton], spacing: 8)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var joinAsShowmanButton: UIButton = createButton(title: R.string.localizable.joinAsShowman())
    private lazy var joinAsPlayerButton: UIButton = createButton(title: R.string.localizable.joinAsPlayer())
    private lazy var joinAsViewerButton: UIButton = createButton(title: R.string.localizable.joinAsViewer())
    
    // MARK: - Progress Bar
    
    private lazy var progressBar: ProgressBar = {
        let view = ProgressBar()
        view.setupIndeterminate()
        view.isHidden = true
        return view
    }()
    
    // MARK: - private properties
    
    private var free: [Bool] = [true, false, false]
    
    private var rules: [String] = []
    
    private var players: [String] = []
    
    private var viewers: [String] = []
    
    private var gameId: Int = 0
    
    private var dispatch: DispatchFunction?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        setup(
            game: GameInfo(
                gameID: 0,
                gameName: "Eefrit's Game (с дискордом)",
                language: "",
                mode: .Classic,
                owner: "Kormak",
                packageName: "Большой мешок сюрпризов",
                passwordRequired: false,
                persons: [
                    ServerPersonInfo(isOnline: true, name: "Eefrit", role: 2),
                    ServerPersonInfo(isOnline: true, name: "Ideality", role: 1),
                    ServerPersonInfo(isOnline: true, name: "Артём Лобов", role: 1)
                ],
                realStartTime: "",
                rules: 2,
                stage: 0,
                stageName: "",
                started: false,
                startTime: "18.12.2022, 12:30:02"
            ),
            showGameName: true,
        state: State.initialState())
        
        startObservingKeyboard()
        setupActions()
    }
    
    deinit {
        stopObservingKeyboard()
    }
    
    // MARK: - Setup
    
    private func setupLayout() {
        
        view.backgroundColor = R.color.gameinfoBackground()
        
        view.addEnclosedSubview(
            innerInfoView,
            insets: NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 48, trailing: 0)
        )
        view.addSubview(buttonsStackView, activateConstraints: [
            buttonsStackView.heightAnchor.constraint(equalToConstant: 48),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        gameNameContainer.addEnclosedSubview(
            gameNameLabel,
            insets: NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        )
        
        innerInfoView.addArrangedSubview(gameNameContainer)
        innerInfoView.addArrangedSubview(scrollView)
        
        setupScrollViewConstrinats()
        
        view.addSubview(progressBar, activateConstraints: [
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupScrollViewConstrinats() {
        scrollView.addSubview(
            scrollStackView,
            activateConstraints: [
                scrollView.contentLayoutGuide.leadingAnchor.constraint(
                    equalTo: scrollStackView.leadingAnchor,
                    constant: -20
                ),
                scrollView.contentLayoutGuide.trailingAnchor.constraint(
                    equalTo: scrollStackView.trailingAnchor
                ),
                scrollView.contentLayoutGuide.topAnchor.constraint(
                    equalTo: scrollStackView.topAnchor
                ),
                scrollView.contentLayoutGuide.bottomAnchor.constraint(
                    equalTo: scrollStackView.bottomAnchor
                ),
                scrollView.frameLayoutGuide.widthAnchor.constraint(equalTo: innerInfoView.widthAnchor),
                scrollStackView.widthAnchor.constraint(equalTo: innerInfoView.widthAnchor, constant: -20)
            ])
    }
    
    private func setupActions() {
        joinAsShowmanButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self, let dataContext = Index.dataContext else { return }
            
            self.dispatch?(ActionCreators.shared.joinGame(dataContext: dataContext, gameId: self.gameId, role: Role.Showman))
        }), for: .touchUpInside)
        
        joinAsPlayerButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self, let dataContext = Index.dataContext else { return }
            
            self.dispatch?(ActionCreators.shared.joinGame(dataContext: dataContext, gameId: self.gameId, role: Role.Player))
        }), for: .touchUpInside)
        
        joinAsViewerButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self, let dataContext = Index.dataContext else { return }
            
            self.dispatch?(ActionCreators.shared.joinGame(dataContext: dataContext, gameId: self.gameId, role: Role.Viewer))
        }), for: .touchUpInside)
    }
    
    private func setupUI(game: GameInfo?, showGameName: Bool, state: State) {
        progressBar.isHidden = !state.online.joinGameProgress
        view.isUserInteractionEnabled = state.online.joinGameProgress
        innerInfoView.isHidden = game == nil
        
        guard let game else { return }
        
        gameNameContainer.isHidden = !showGameName
        gameNameLabel.text = game.gameName
        
        ownerLabel.text = game.owner
        packageNameLabel.text = game.packageName
        
        passwordInfoStackView.isHidden = !game.passwordRequired
        passwordInput.isEnabled = !state.online.joinGameProgress
        passwordInput.text = state.online.password
    }
    
    private func createButton(title: String) -> UIButton {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = R.color.standartButtonBackground()
        button.setTitle(title, for: .normal)
        return button
    }
    
    private func createTitleLabel(title: String) -> UILabel {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 21)
        label.textColor = .white
        label.text = title
        return label
    }
    
    private func createValueLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 27)
        label.textColor = .white
        return label
    }
    
    private func createStackView(views: [UIView], spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = spacing
        views.forEach { view in
            stackView.addArrangedSubview(view)
        }
        return stackView
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left)
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(RulesCollectionViewCell.self, forCellWithReuseIdentifier: "RulesCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return collectionView
    }
    
    // MARK: - Public setup
    
    func setup(dispatch: @escaping DispatchFunction) {
        self.dispatch = dispatch
    }
    
    func setup(game: GameInfo?, showGameName: Bool, state: State) {
        setupUI(game: game, showGameName: showGameName, state: state)
        
        guard let game else { return }
        
        self.rules = generateRuleDescriptions(rules: game.rules, isSimple: game.mode == .Simple)
        setupCollectionView(rulesCollectionView, data: rules)
        
        setupPersons(persons: game.persons)
        
        setupCollectionView(playersCollectionView, data: players)
        setupCollectionView(viewersCollectionView, data: viewers)
        
        stageLabel.text = buildStage(stage: game.stage, stageName: game.stageName)
        createdTimeLabel.text = game.startTime
        startedTimeLabel.text = game.realStartTime
        
        joinGameErrorLabel.text = state.online.joingGameError
        
        self.gameId = game.gameID
        
        let canJoinGame: Bool = state.common.isConnected && !state.online.joinGameProgress && !(game.passwordRequired && state.online.password.isEmpty)
        
        joinAsShowmanButton.isEnabled = canJoinGame && free[Role.Showman.rawValue]
        
        joinAsPlayerButton.isEnabled = canJoinGame && free[Role.Player.rawValue]
        
        joinAsViewerButton.isEnabled = canJoinGame
    }
    
    func setupCollectionView(_ collectionView: UICollectionView, data: [String]) {
        collectionView.isHidden = data.isEmpty
        collectionView.reloadData()
    }
    
    // MARK: - build rules
    
    private func generateRuleDescriptions(rules: Int, isSimple: Bool) -> [String] {
        let falseStartMask = 1
        let oralRulesMask = 2
        let errorTolerantMask = 4
        
        var result = [String]()
        
        if isSimple {
            result.append(R.string.localizable.sport())
        } else {
            result.append(R.string.localizable.tv())
        }
        
        if rules & falseStartMask == 0 {
            result.append(R.string.localizable.nofalsestart())
        }
        
        if rules & oralRulesMask > 0 {
            result.append(R.string.localizable.oral())
        }
        
        if rules & errorTolerantMask > 0 {
            result.append(R.string.localizable.errorTolerant())
        }
        
        return result
    }
    
    // MARK: - build stage

    private func buildStage(stage: Int, stageName: String) -> String {
        let stageNames = [
            R.string.localizable.created(),
            R.string.localizable.started(),
            R.string.localizable.round() + ": \(stageName)",
            R.string.localizable.final(),
        ]
        
        guard (0..<stageNames.count).contains(stage) else {
            return R.string.localizable.gameFinished()
        }
        
        return stageNames[stage]
    }
    
    // MARK: - persons
    
    private func setupPersons(persons: [ServerPersonInfo]) {
        players = []
        viewers = []
        free = [true, false, false]
        showmanNameLabel.text = ""
        
        for person in persons {
            if !person.isOnline {
                free[person.role] = true
            } else {
                switch person.role {
                case Role.Showman.rawValue:
                    showmanNameLabel.text = person.name
                case Role.Player.rawValue:
                    players.append(person.name)
                default:
                    viewers.append(person.name)
                }
            }
        }
    }
}

extension GameInfoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
              let textRange = Range(range, in: text),
              let dispatch else {
            return true
        }
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        dispatch(ActionCreators.shared.passwordChanged(newPassword: updatedText))
        return false
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension GameInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    enum CollectionViewType {
        case rules
        case players
        case viewers
    }
    
    private func collectionViewType(for collectionView: UICollectionView) -> CollectionViewType {
        switch collectionView {
        case rulesCollectionView:
            return .rules
        case playersCollectionView:
            return .players
        case viewersCollectionView:
            return .viewers
        default:
            fatalError("Unknown collection view")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionViewType(for: collectionView) {
        case .rules:
            return rules.count
        case .players:
            return players.count
        case .viewers:
            return viewers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "RulesCollectionViewCell",
            for: indexPath
        ) as? RulesCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        switch collectionViewType(for: collectionView) {
        case .rules:
            cell.fill(title: rules[indexPath.row])
        case .players:
            cell.fill(title: players[indexPath.row])
        case .viewers:
            cell.fill(title: viewers[indexPath.row])
        }
        
        return cell
    }
}
