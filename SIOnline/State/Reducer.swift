//
//  Reducer.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 17.05.2022.
//

import ReSwift

let reducer: Reducer<State> = { action, state in
    var state = state ?? State.initialState()
    
    guard let action = action as? KnownAction else { return state }
    
    switch action {
    case .isConnectedChanged(let isConnected):
        state.common.isConnected = isConnected
    case .computerAccountsChanged(let computerAccounts):
        state.common.computerAccounts = computerAccounts
    case .navigateToLogin:
        state.ui.previousMainView = state.ui.mainView
        state.ui.mainView = MainView.login
    case .showSettings(let show):
        state.ui.areSettingsVisible = show
    case .navigateToHowToPlay:
        state.ui.previousMainView = state.ui.mainView
        state.ui.mainView = MainView.about
    case .navigateBack:
        state.ui.mainView = state.ui.previousMainView
    case .loginChanged(let newLogin):
        state.user.login = newLogin
    case .loginStart:
        state.login.inProgress = true
        state.login.errorMessage = ""
    case .loginEnd(let error):
        state.login.inProgress = false
        state.login.errorMessage = error
    case .navigateToWelcome:
        state.ui.previousMainView = state.ui.mainView
        state.ui.mainView = MainView.welcome
    case .navigateToNewGame:
        state.ui.previousMainView = state.ui.mainView
        state.ui.mainView = MainView.newGame
    case .navigateToGames:
        state.online.selectedGameId = -1
        state.ui.previousMainView = state.ui.mainView
        state.ui.mainView = MainView.games
    case .unselectGame:
        state.online.selectedGameId = -1
    case .navigateToLobby:
        state.ui.previousMainView = state.ui.mainView
        state.ui.mainView = MainView.lobby
        state.online.games = [:]
        state.online.users = []
        state.online.messages = []
        state.online.inProgress = true
        state.online.error = ""
    case .clearGames:
        state.online.games = [:]
    case .receiveGames(let games):
        state.online.games = Dictionary<Int, GameInfo>.create(collection: games, selector: { $0.gameID })
    case .receiveUsers(let users):
        state.online.users = users
    case .receiveMessage(let sender, let message):
        state.online.messages.append(ChatMessage(sender: sender, text: message))
    case .gameCreated(let game):
        state.online.games[game.gameID] = game
    case .gameChanged(let game):
        state.online.games[game.gameID] = game
    case .gameDeleted(let gameId):
        state.online.games[gameId] = nil
        if state.online.selectedGameId == gameId {
            state.online.selectedGameId = -1
        }
    case .userJoined(let login):
        if state.online.users.contains(login) {
            Logger.log(message: "User \(login) already exists in users list!")
        } else {
            state.online.users.append(login)
        }
    case .userLeaved(let login):
        state.online.users.removeAll(where: { $0 == login })
    default:
        fatalError("not yet implemented")
    }
    return state
}


