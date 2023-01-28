//
//  GameInfoViewController.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 04.11.2022.
//

import AlignedCollectionViewFlowLayout
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
        
        collectionView.heightAnchor.constraint(equalToConstant: 36).isActive = true
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
    
    // MARK: - private properties
    
    private var rules: [String] = []
    
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
                passwordRequired: true,
                persons: [
                    ServerPersonInfo(isOnline: true, name: "Eefrit", role: 2)
                ],
                realStartTime: "",
                rules: 2,
                stage: 0,
                stageName: "",
                started: false,
                startTime: ""
            ),
            showGameName: true)
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
        innerInfoView.addArrangedSubview(UIView())
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        
        scrollView.addEnclosedSubview(
            stackView,
            insets: NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        )
        
        stackView.addArrangedSubview(hostStackView)
        stackView.addArrangedSubview(questionPackageStackView)
        stackView.addArrangedSubview(rulesStackView)
        stackView.addArrangedSubview(showmanStackView)
    }
    
    // MARK: - Public setup
    
    func setup(game: GameInfo, showGameName: Bool) {
        gameNameContainer.isHidden = !showGameName
        gameNameLabel.text = game.gameName
        
        ownerLabel.text = game.owner
        packageNameLabel.text = game.packageName
        
        self.rules = buildRules(rules: game.rules, isSimple: game.mode == .Simple)
        rulesCollectionView.reloadData()
        
        setupPersons(persons: game.persons)
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
    
    // MARK: - persons
    
    private func setupPersons(persons: [ServerPersonInfo]) {
        for person in persons {
            if person.role == Role.Showman.rawValue {
                showmanNameLabel.text = person.name
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension GameInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "RulesCollectionViewCell",
            for: indexPath
        ) as? RulesCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.fill(title: rules[indexPath.row])
        return cell
    }
    
    
}
