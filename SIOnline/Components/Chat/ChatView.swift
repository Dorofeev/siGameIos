//
//  ChatView.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 21.05.2023.
//

import UIKit
import ReSwift

class ChatViewController: UIViewController {
    private let chatLog: ChatLogView
    private let inputField: UITextField
    private let emojiPicker: ChatInputEmojiPicker
    
    private var dispatch: DispatchFunction?
    
    init() {
        chatLog = ChatLogView()
        inputField = UITextField()
        emojiPicker = ChatInputEmojiPicker()
        
        super.init(nibName: nil, bundle: nil)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.white
        
        let chatBodyHost = UIView()
        view.addEnclosedSubview(chatBodyHost)
        
        chatLog.translatesAutoresizingMaskIntoConstraints = false
        chatBodyHost.addSubview(chatLog)
        
        emojiPicker.translatesAutoresizingMaskIntoConstraints = false
        chatBodyHost.addSubview(emojiPicker)
        
        inputField.translatesAutoresizingMaskIntoConstraints = false
        chatBodyHost.addSubview(inputField)
        
        NSLayoutConstraint.activate([
            chatLog.topAnchor.constraint(equalTo: chatBodyHost.topAnchor, constant: 7),
            chatLog.leadingAnchor.constraint(equalTo: chatBodyHost.leadingAnchor, constant: 7),
            chatLog.trailingAnchor.constraint(equalTo: chatBodyHost.trailingAnchor, constant: 7),
            chatLog.bottomAnchor.constraint(equalTo: inputField.topAnchor, constant: 12),
            
            emojiPicker.leadingAnchor.constraint(equalTo: chatBodyHost.leadingAnchor),
            emojiPicker.trailingAnchor.constraint(equalTo: chatBodyHost.trailingAnchor),
            emojiPicker.bottomAnchor.constraint(equalTo: inputField.topAnchor),
            
            inputField.leadingAnchor.constraint(equalTo: chatBodyHost.leadingAnchor),
            inputField.trailingAnchor.constraint(equalTo: chatBodyHost.trailingAnchor),
            inputField.bottomAnchor.constraint(equalTo: chatBodyHost.bottomAnchor),
            inputField.heightAnchor.constraint(equalToConstant: 45.0)
        ])
        
        inputField.delegate = self
        
        // Apply CSS styles
        chatBodyHost.backgroundColor = R.color.backgroundColor()
        
        chatLog.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        
        inputField.backgroundColor = UIColor(red: 192/255, green: 207/255, blue: 244/255, alpha: 1)
        inputField.font = UIFont.systemFont(ofSize: 16)
        inputField.textColor = UIColor.black
        inputField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 1))
        inputField.leftViewMode = .always
        inputField.borderStyle = .none
        inputField.placeholder = "Type a message..."
        inputField.returnKeyType = .send
        inputField.autocapitalizationType = .none
        inputField.autocorrectionType = .no
        
        inputField.addTarget(self, action: #selector(sendMessage), for: .editingDidEndOnExit)
        
        inputField.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputField.becomeFirstResponder()
    }
    
    func newState(state: State) {
        // Update the UI based on the new state
        chatLog.setMessages(state.online.messages)
        chatLog.setUser(state.user.login)
        inputField.text = state.online.currentMessage
        inputField.isEnabled = state.common.isConnected
    }
    
    func setup(dispatch: @escaping DispatchFunction) {
        self.dispatch = dispatch
    }
    
    @objc private func sendMessage() {
        if let message = inputField.text, !message.isEmpty {
            // Dispatch an action to send the message
            dispatch?(ActionCreators.shared.sendMessage(dataContext: Index.dataContext!))
        }
    }
    
    @objc private func emojiSelected(emoji: String) {
        if let currentMessage = inputField.text {
            inputField.text = currentMessage + emoji
        }
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y = -keyboardSize.height
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}
