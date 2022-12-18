//
//  GameInfoViewController.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 04.11.2022.
//

import UIKit

class GameInfoViewController: UIViewController {
    
    // color: white;
    
    // MARK: - Views
    
    private lazy var innerInfoView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    private lazy var gameNameContainer = UIView()
    private lazy var gameNameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 36)
        label.textColor = .white
        return label
    }()
    
    private lazy var scrollView = UIScrollView()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupLayout()
        
        setup(
            game: GameInfo(
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
            insets: NSDirectionalEdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0)
        )
        
        gameNameContainer.addEnclosedSubview(
            gameNameLabel,
            insets: NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        )
        
        innerInfoView.addArrangedSubview(gameNameContainer)
        innerInfoView.addArrangedSubview(scrollView)
        
    }
    
    // MARK: - Public setup
    
    func setup(game: GameInfo, showGameName: Bool) {
        gameNameContainer.isHidden = !showGameName
        gameNameLabel.text = game.gameName
    }
}
