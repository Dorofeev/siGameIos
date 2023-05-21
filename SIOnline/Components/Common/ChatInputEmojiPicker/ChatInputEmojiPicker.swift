//
//  ChatInputEmojiPicker.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 21.05.2023.
//

import UIKit
import EmojiPicker

class ChatInputEmojiPicker: UIView {
    private let emojiButton: UIButton
    
    var onEmojiClick: ((String) -> Void)?
    
    override init(frame: CGRect) {
        emojiButton = UIButton(type: .custom)
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.clear
        
        emojiButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emojiButton)
        
        NSLayoutConstraint.activate([
            emojiButton.topAnchor.constraint(equalTo: topAnchor),
            emojiButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            emojiButton.widthAnchor.constraint(equalToConstant: 45.0),
            emojiButton.heightAnchor.constraint(equalToConstant: 45.0),
            emojiButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            emojiButton.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        emojiButton.setTitle("🙂", for: .normal)
        emojiButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        emojiButton.addTarget(self, action: #selector(emojiButtonTapped), for: .touchUpInside)
        
    }
    
    @objc private func emojiButtonTapped() {
        print("hoba")
        let viewController = EmojiPickerViewController()
        viewController.delegate = self
        viewController.sourceView = emojiButton
        viewController.selectedEmojiCategoryTintColor = UIColor(red: 217/255, green: 227/255, blue: 249/255, alpha: 1)
        self.window?.rootViewController?.present(viewController, animated: true)
        
    }
}

extension ChatInputEmojiPicker: EmojiPickerDelegate {
    func didGetEmoji(emoji: String) {
        onEmojiClick?(emoji)
    }
}
