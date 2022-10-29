//
//  GameTableViewCell.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 20.09.2022.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    static let reusableIdentifier = "GameTableViewCell"
    
    private lazy var gameNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var passwordRequiredLabel: UILabel = {
        let label = UILabel()
        label.text = "🔓"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.backgroundView?.backgroundColor = .clear
        self.selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(_ info: GameInfo) {
        gameNameLabel.text = info.gameName
        passwordRequiredLabel.isHidden = !info.passwordRequired
    }

    private func setupLayout() {
        contentView.addSubview(gameNameLabel, activateConstraints: [
            gameNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            gameNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            gameNameLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -40
            ),
            gameNameLabel.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        contentView.addSubview(passwordRequiredLabel, activateConstraints: [
            passwordRequiredLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -20
            ),
            passwordRequiredLabel.centerYAnchor.constraint(equalTo: gameNameLabel.centerYAnchor)
        ])
    }
}
