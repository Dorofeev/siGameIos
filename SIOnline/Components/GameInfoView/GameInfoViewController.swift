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
    
    private lazy var innerInfoView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        return view
    }()
    
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
    
    private lazy var hostStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(hostLabel)
        stackView.addArrangedSubview(ownerLabel)
        return stackView
    }()
    
    private lazy var hostLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 21)
        label.textColor = .white
        label.text = R.string.localizable.host()
        return label
    }()
    
    private lazy var ownerLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 27)
        label.textColor = .white
        return label
    }()
    
    // MARK: - question package
    
    private lazy var questionPackageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(questionPackageLabel)
        stackView.addArrangedSubview(packageNameLabel)
        return stackView
    }()
    
    private lazy var questionPackageLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 21)
        label.textColor = .white
        label.text = R.string.localizable.questionPackage()
        return label
    }()
    
    private lazy var packageNameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 27)
        label.textColor = .white
        return label
    }()
    
    // MARK: - rules
    
    private lazy var rulesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.addArrangedSubview(rulesLabel)
        stackView.addArrangedSubview(rulesCollectionView)
        return stackView
    }()
    
    private lazy var rulesLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 21)
        label.textColor = .white
        label.text = R.string.localizable.rules()
        return label
    }()
    
    private lazy var rulesCollectionView: UICollectionView = {
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
    }()
    
    // MARK: - Showman
    
    private lazy var showmanStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(showmanLabel)
        stackView.addArrangedSubview(showmanNameLabel)
        return stackView
    }()
    
    private lazy var showmanLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 21)
        label.textColor = .white
        label.text = R.string.localizable.showman()
        return label
    }()
    
    private lazy var showmanNameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 27)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Players
    
    private lazy var playersStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.addArrangedSubview(playersLabel)
        stackView.addArrangedSubview(playersCollectionView)
        return stackView
    }()
    
    private lazy var playersLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 21)
        label.textColor = .white
        label.text = R.string.localizable.players()
        return label
    }()
    
    private lazy var playersCollectionView: UICollectionView = {
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
    }()
    
    // MARK: - Viewers
    
    private lazy var viewersStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.addArrangedSubview(viewersLabel)
        stackView.addArrangedSubview(viewersCollectionView)
        return stackView
    }()
    
    private lazy var viewersLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 21)
        label.textColor = .white
        label.text = R.string.localizable.viewers()
        return label
    }()
    
    private lazy var viewersCollectionView: UICollectionView = {
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
    }()
    
    // MARK: - Status
    
    private lazy var statusStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(statusLabel)
        stackView.addArrangedSubview(stageLabel)
        return stackView
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 21)
        label.textColor = .white
        label.text = R.string.localizable.status()
        return label
    }()
    
    private lazy var stageLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 27)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Created
    
    private lazy var createdStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(createdLabel)
        stackView.addArrangedSubview(createdTimeLabel)
        return stackView
    }()
    
    private lazy var createdLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 21)
        label.textColor = .white
        label.text = R.string.localizable.created()
        return label
    }()
    
    private lazy var createdTimeLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 27)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Started
    
    private lazy var startedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(startedLabel)
        stackView.addArrangedSubview(startedTimeLabel)
        return stackView
    }()
    
    private lazy var startedLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 21)
        label.textColor = .white
        label.text = R.string.localizable.started()
        return label
    }()
    
    private lazy var startedTimeLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 27)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Password Info
    
    private lazy var passwordInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(passwordLabel)
        stackView.addArrangedSubview(passwordInput)
        passwordInput.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20).isActive = true
        return stackView
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 21)
        label.textColor = .white
        label.text = R.string.localizable.password()
        return label
    }()
    
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
    
    // MARK: - private properties
    
    private var free: [Bool] = [true, false, false]
    
    private var rules: [String] = []
    
    private var players: [String] = []
    
    private var viewers: [String] = []
    
    private var dispatch: DispatchFunction?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
    }
    
    deinit {
        stopObservingKeyboard()
    }
    
    // MARK: - Setup
    
    private func setup() {
        view.backgroundColor = R.color.gameinfoBackground()
    }
    
    private func setupLayout() {
        view.addEnclosedSubview(
            innerInfoView,
            insets: NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        )
        
        gameNameContainer.addEnclosedSubview(
            gameNameLabel,
            insets: NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        )
        
        innerInfoView.addArrangedSubview(gameNameContainer)
        innerInfoView.addArrangedSubview(scrollView)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        
        scrollView.addSubview(
            stackView,
            activateConstraints: [
                scrollView.contentLayoutGuide.leadingAnchor.constraint(
                    equalTo: stackView.leadingAnchor,
                    constant: -20
                ),
                scrollView.contentLayoutGuide.trailingAnchor.constraint(
                    equalTo: stackView.trailingAnchor
                ),
                scrollView.contentLayoutGuide.topAnchor.constraint(
                    equalTo: stackView.topAnchor
                ),
                scrollView.contentLayoutGuide.bottomAnchor.constraint(
                    equalTo: stackView.bottomAnchor
                ),
                scrollView.frameLayoutGuide.widthAnchor.constraint(equalTo: innerInfoView.widthAnchor),
                stackView.widthAnchor.constraint(equalTo: innerInfoView.widthAnchor, constant: -20)
        ])
        
        stackView.addArrangedSubview(hostStackView)
        stackView.addArrangedSubview(questionPackageStackView)
        stackView.addArrangedSubview(rulesStackView)
        stackView.addArrangedSubview(showmanStackView)
        stackView.addArrangedSubview(playersStackView)
        stackView.addArrangedSubview(viewersStackView)
        stackView.addArrangedSubview(statusStackView)
        stackView.addArrangedSubview(createdStackView)
        stackView.addArrangedSubview(startedStackView)
        stackView.addArrangedSubview(passwordInfoStackView)
        stackView.addArrangedSubview(joinGameErrorView)
    }
    
    // MARK: - Public setup
    
    func setup(dispatch: @escaping DispatchFunction) {
        self.dispatch = dispatch
    }
    
    func setup(game: GameInfo, showGameName: Bool, state: State) {
        gameNameContainer.isHidden = !showGameName
        gameNameLabel.text = game.gameName
        
        ownerLabel.text = game.owner
        packageNameLabel.text = game.packageName
        
        self.rules = buildRules(rules: game.rules, isSimple: game.mode == .Simple)
        rulesCollectionView.reloadData()
        rulesCollectionView.isHidden = rules.isEmpty
        
        setupPersons(persons: game.persons)
        playersCollectionView.reloadData()
        viewersCollectionView.reloadData()
        
        viewersCollectionView.isHidden = viewers.isEmpty
        playersCollectionView.isHidden = players.isEmpty
        
        stageLabel.text = buildStage(stage: game.stage, stageName: game.stageName)
        createdTimeLabel.text = game.startTime
        startedTimeLabel.text = game.realStartTime
        
        passwordInfoStackView.isHidden = !game.passwordRequired
        passwordInput.isEnabled = !state.online.joinGameProgress
        passwordInput.text = state.online.password
        
        joinGameErrorLabel.text = state.online.joingGameError
    }
    
    // MARK: - build rules
    
    private func buildRules(rules: Int, isSimple: Bool) -> [String] {
        var result = [String]()
        
        if isSimple {
            result.append(R.string.localizable.sport())
        } else {
            result.append(R.string.localizable.tv())
        }
        
        if rules & 1 == 0 {
            result.append(R.string.localizable.nofalsestart())
        }
        
        if rules & 2 > 0 {
            result.append(R.string.localizable.oral())
        }
        
        if rules & 4 > 0 {
            result.append(R.string.localizable.errorTolerant())
        }
        
        return result
    }
    
    // MARK: - build stage

    private func buildStage(stage: Int, stageName: String) -> String {
        switch stage {
        case 0:
            return R.string.localizable.created()
        case 1:
            return R.string.localizable.started()
        case 2:
            return R.string.localizable.round() + ": \(stageName)"
        case 3:
            return R.string.localizable.final()
        default:
            return R.string.localizable.gameFinished()
        }
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
            } else if person.role == Role.Showman.rawValue {
                showmanNameLabel.text = person.name
            } else if person.role == Role.Player.rawValue {
                players.append(person.name)
            } else {
                viewers.append(person.name)
            }
        }
    }
}

extension GameInfoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            dispatch?(ActionCreators.shared.passwordChanged(newPassword: updatedText))
        }
        return false
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension GameInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == rulesCollectionView {
            return rules.count
        } else if collectionView == playersCollectionView {
            return players.count
        } else {
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
        
        if collectionView == rulesCollectionView {
            cell.fill(title: rules[indexPath.row])
        } else if collectionView == playersCollectionView {
            cell.fill(title: players[indexPath.row])
        } else {
            cell.fill(title: viewers[indexPath.row])
        }
        
        return cell
    }
}
