//
//  ChatLogView.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 08.04.2023.
//

import UIKit

class ChatLogView: UIView {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private var messages: [ChatMessage] = [] {
        didSet {
            stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            for (index, message) in messages.enumerated() {
                let messageLabel = UILabel()
                messageLabel.font = UIFont.systemFont(ofSize: 14)
                messageLabel.numberOfLines = 0
                
                if !message.sender.isEmpty {
                    let attributedString = NSMutableAttributedString(string: "\(message.sender): ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
                    attributedString.append(NSAttributedString(string: message.text))
                    messageLabel.attributedText = attributedString
                    
                    messageLabel.isUserInteractionEnabled = true
                    messageLabel.tag = index
                    messageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMessageTap(sender:))))
                } else {
                    messageLabel.text = message.text
                }
                
                switch message.messageLevel {
                case .system:
                    messageLabel.textColor = .white
                    messageLabel.font = UIFont.boldSystemFont(ofSize: 14)
                case .warning:
                    messageLabel.textColor = R.color.darkRed()
                default: break
                }
                
                messageLabel.backgroundColor = MentionHelpers.hasUserMentioned(message: message.text, user: user)
                ? .white.withAlphaComponent(0.15)
                : .clear
                
                stackView.addArrangedSubview(messageLabel)
            }
        }
    }
    
    private var user: String = ""
    private var onNicknameClick: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setMessages(_ messages: [ChatMessage]) {
        self.messages = messages
        scrollToBottom()
    }
    
    func setUser(_ user: String) {
        self.user = user
    }
    
    func setOnNicknameClick(_ onNicknameClick: @escaping (String) -> Void) {
        self.onNicknameClick = onNicknameClick
    }
    
    private func scrollToBottom() {
        scrollView.layoutIfNeeded()
        scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height), animated: false)
    }
    
    @objc func onMessageTap(sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        onNicknameClick?(messages[index].sender)
    }
}


