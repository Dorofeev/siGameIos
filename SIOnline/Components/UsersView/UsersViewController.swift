//
//  UsersViewController.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 30.05.2023.
//

import UIKit
import ReSwift

private struct UsersViewStateProps {
    var chatMode: ChatMode
    var usersCount: Int
    var isLobbyChatHidden: Bool
}

private struct UsersViewOwnProps {
    var onChatModeChanged: (ChatMode) -> Void
}

class UsersViewController: UIViewController {
    let lobbyMenu = LobbyMenu()
    let chat = ChatViewController()
    let usersList = UsersListView()
    
    private var dispatch: DispatchFunction?
    
    private var props: UsersViewStateProps?
    
    func newState(state: State) {
        // Handle state updates from the Redux store
        let props = UsersViewStateProps(
            chatMode: state.online.chatMode,
            usersCount: state.online.users.count,
            isLobbyChatHidden: state.settingsState.isLobbyChatHidden
        )
        self.props = props
        updateUI(with: props)
        chat.newState(state: state)
        usersList.newState(state: state)
    }
    
    private func updateUI(with props: UsersViewStateProps) {
        if props.isLobbyChatHidden {
            // Hide the chat view
            view.isHidden = true
        } else {
            // Show the chat view
            view.isHidden = false
            
            // Update the UI based on the chat mode
            if props.chatMode == .chat {
                showChat()
            } else if props.chatMode == .users {
                showUsersList()
            }
        }
    }
    
    func showChat() {
        // Remove the users list from the view
        usersList.removeFromSuperview()
        
        // Add the chat view to the view
        chat.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        addChild(chat)
        view.addSubview(chat.view)
        chat.didMove(toParent: self)
    }
    
    func showUsersList() {
        // Remove the chat view from the view
        chat.view.removeFromSuperview()
        
        // Add the users list to the view
        usersList.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(usersList)
    }
    
    // Actions
    func chatModeChanged(chatMode: ChatMode) {
        // Dispatch the chat mode changed action
        dispatch?(ActionCreators.shared.chatModeChanged(chatMode: chatMode))
    }
    
    func setup(dispatch: @escaping DispatchFunction) {
        self.dispatch = dispatch
        lobbyMenu.setup(dispatch: dispatch)
        chat.setup(dispatch: dispatch)
    }
}

extension UsersViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Layout the subviews
        let lobbyMenuWidth: CGFloat = 50
        let widthWithoutLobbyMenu = view.frame.width - lobbyMenuWidth
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        let chatHostTitleView = UIView(frame: CGRect(x: 0, y: 0, width: widthWithoutLobbyMenu, height: 50))
        chat.view.frame = CGRect(x: 0, y: 50, width: widthWithoutLobbyMenu, height: view.frame.height - 50)
        usersList.frame = CGRect(x: 0, y: 50, width: widthWithoutLobbyMenu, height: view.frame.height - 50)
        
        // Setup headerView
        headerView.backgroundColor = R.color.gameinfoBackground()
        view.addSubview(headerView)
        
        // Setup chatHostTitleView
        chatHostTitleView.backgroundColor = R.color.standartButtonBackground()
        headerView.addSubview(chatHostTitleView)
        
        // Setup LobbyMenu
        
        lobbyMenu.frame = CGRect(x: widthWithoutLobbyMenu, y: 0, width: lobbyMenuWidth, height: 50)
        headerView.addSubview(lobbyMenu)
        
        // Setup title labels
        let chatLabel = UILabel(frame: CGRect(x: 0, y: 0, width: chatHostTitleView.frame.width / 2, height: chatHostTitleView.frame.height))
        let usersLabel = UILabel(frame: CGRect(x: chatHostTitleView.frame.width / 2, y: 0, width: chatHostTitleView.frame.width / 2, height: chatHostTitleView.frame.height))
        
        chatLabel.text = R.string.localizable.chat()
        chatLabel.textAlignment = .center
        chatLabel.textColor = props?.chatMode == .chat ? .white : .lightGray
        chatLabel.backgroundColor = props?.chatMode == .chat ? R.color.loginBackground() : .clear
        chatHostTitleView.addSubview(chatLabel)
        
        if let props {
            usersLabel.text = R.string.localizable.users() + " (\(props.usersCount))"
        }
        usersLabel.textAlignment = .center
        usersLabel.textColor = props?.chatMode == .users ? .white : .lightGray
        usersLabel.backgroundColor = props?.chatMode == .users ? R.color.loginBackground() : .clear
        chatHostTitleView.addSubview(usersLabel)
        
        // Add tap gesture recognizer to labels
        let chatTapGesture = UITapGestureRecognizer(target: self, action: #selector(chatLabelTapped))
        chatLabel.isUserInteractionEnabled = true
        chatLabel.addGestureRecognizer(chatTapGesture)
        
        let usersTapGesture = UITapGestureRecognizer(target: self, action: #selector(usersLabelTapped))
        usersLabel.isUserInteractionEnabled = true
        usersLabel.addGestureRecognizer(usersTapGesture)
        
        view.backgroundColor = R.color.backgroundColor()
    }
    
    @objc func chatLabelTapped() {
        chatModeChanged(chatMode: .chat)
    }
    
    @objc func usersLabelTapped() {
        chatModeChanged(chatMode: .users)
    }
}
