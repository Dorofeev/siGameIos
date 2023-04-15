//
//  State.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 08.04.2022.
//

import UIKit

struct State {
    var user: StateUser
    var login: StateLogin
    var ui: StateUI
    var online: StateOnline
    var game: StateGame
    var run: RunState
    var common: StateCommon
    var settingsState: SettingsState
    var siPackages: StateSiPackages
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
                areSettingsVisible: false,
                windowHeight: Int(UIScreen.main.bounds.height),
                isSettingGameButtonKey: false
            ),
            online: StateOnline(
                inProgress: false,
                error: "",
                gamesFilter: 0,
                gamesSearch: "",
                games: [:],
                selectedGameId: -1,
                users: [],
                currentMessage: "",
                messages: [
                    ChatMessage(
                        sender: R.string.localizable.appUser(),
                        text: R.string.localizable.greeting(),
                        messageLevel: .system
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
                error: nil,
                avatarLoadProgress: false,
                avatarLoadError: nil
            ),
            settingsState: SettingsState.initialState(),
            siPackages: StateSiPackages(
                packages: [],
                authors: [],
                tags: [],
                publishers: [],
                isLoading: false
            )
        )
    }
}

struct StateUser {
    var login: String
    var avatar: String?
}

struct StateLogin {
    var inProgress: Bool
    var errorMessage: String?
}

struct StateUI {
    var mainView: MainView
    var previousMainView: MainView
    var onlineView: OnlineMode
    var windowWidth: Int
    var areSettingsVisible: Bool
    var windowHeight: Int
    var isSettingGameButtonKey: Bool
}

struct StateOnline {
    var inProgress: Bool
    var error: String
    var gamesFilter: Int
    var gamesSearch: String
    var games: [Int: GameInfo]
    var selectedGameId: Int
    var users: [String]
    var currentMessage: String
    var messages: [ChatMessage]
    var password: String
    var chatMode: ChatMode
    var newGameShown: Bool
    var gameCreationProgress: Bool
    var gameCreationError: String?
    var joinGameProgress: Bool
    var joingGameError: String?
    var uploadPackageProgress: Bool
    var uploadPackagePercentage: Double
}

struct StateGame {
    var name: String
    var password: String
    var package: GamePackage
    var type: GameType
    var role: Role
    var isShowmanHuman: Bool
    var playersCount: Int
    var humanPlayersCount: Int
    var id: Int
    var isAutomatic: Bool
}

struct GamePackage {
    var type: PackageType
    var name: String
    var data: File?
    var id: String?
}

struct StateCommon {
    var computerAccounts: [String]?
    var isConnected: Bool
    var serverName: String?
    var error: String?
    var serverLicense: String?
    var avatarLoadProgress: Bool
    var avatarLoadError: String?
}
struct StateSiPackages {
    var packages: [SIPackageInfo]
    var authors: [SearchEntity]
    var tags: [SearchEntity]
    var publishers: [SearchEntity]
    var isLoading: Bool
 }

