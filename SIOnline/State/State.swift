//
//  State.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 08.04.2022.
//

import UIKit

struct State {
    var user: StateUser
    let login: StateLogin
    let ui: StateUI
    var online: StateOnline
    var game: StateGame
    let run: RunState
    let common: StateCommon
    var settingsState: SettingsState
    
    static func initialState() -> State {
        return State(
            user: StateUser(login: ""),
            login: StateLogin(
                inProgress: false,
                errorMessage: nil
            ),
            ui: StateUI(
                mainView: .loading,
                previousMainView: .loading,
                onlineView: .games,
                windowWidth: Int(UIScreen.main.bounds.width),
                areSettingsVisible: false
            ),
            online: StateOnline(
                inProgress: false,
                error: "",
                gamesFilter: .noFilter,
                gamesSearch: "",
                games: [:],
                selectedGameId: -1,
                users: [],
                currentMessage: "",
                messages: [
                    ChatMessage(
                        sender: R.string.localizable.appUser(),
                        text: R.string.localizable.greeting()
                    )
                ],
                password: "",
                chatMode: .chat,
                newGameShown: false,
                gameCreationProgress: false,
                gameCreationError: nil,
                joinGameProgress: false,
                joingGameError: nil,
                uploadPackageProgress: false,
                uploadPackagePercentage: 0
            ),
            game: StateGame(
                name: "",
                password: "",
                package: GamePackage(
                    type: .random,
                    name: "",
                    data: nil,
                    id: nil
                ),
                type: .Simple,
                role: .Player,
                isShowmanHuman: false,
                playersCount: 3,
                humanPlayersCount: 0,
                id: -1,
                isAutomatic: false
            ),
            run: RunState.runInitialState(),
            common: StateCommon(
                computerAccounts: nil,
                isConnected: true,
                serverName: nil,
                error: nil
            ),
            settingsState: SettingsState.initialState()
        )
    }
}

struct StateUser {
    var login: String
}

struct StateLogin {
    let inProgress: Bool
    let errorMessage: String?
}

struct StateUI {
    let mainView: MainView
    let previousMainView: MainView
    let onlineView: OnlineMode
    let windowWidth: Int
    let areSettingsVisible: Bool
}

struct StateOnline {
    let inProgress: Bool
    let error: String
    let gamesFilter: GamesFilter
    let gamesSearch: String
    let games: [Int: GameInfo]
    var selectedGameId: Int
    let users: [String]
    let currentMessage: String
    let messages: [ChatMessage]
    let password: String
    let chatMode: ChatMode
    let newGameShown: Bool
    let gameCreationProgress: Bool
    let gameCreationError: String?
    let joinGameProgress: Bool
    let joingGameError: String?
    let uploadPackageProgress: Bool
    let uploadPackagePercentage: Int
}

struct StateGame {
    var name: String
    var password: String
    let package: GamePackage
    var type: GameType
    var role: Role
    let isShowmanHuman: Bool
    var playersCount: Int
    var humanPlayersCount: Int
    let id: Int
    let isAutomatic: Bool
}

struct GamePackage {
    let type: PackageType
    let name: String
    let data: Data?
    let id: String?
}

struct StateCommon {
    let computerAccounts: [String]?
    let isConnected: Bool
    let serverName: String?
    let error: String?
}
