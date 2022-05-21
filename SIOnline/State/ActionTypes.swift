//
//  ActionTypes.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 15.04.2022.
//

import Foundation
import ReSwift

typealias KnownAction = ActionTypes

enum ActionTypes: Action {
    case isConnectedChanged(isConnected: Bool)
    case computerAccountsChanged(computerAccounts: [String])
    case navigateToLogin
    case showSettings(show: Bool)
    case navigateToHowToPlay
    case navigateBack
    case loginChanged(newLogin: String)
    case loginStart
    case loginEnd(error: String?)
    case navigateToWelcome
    case navigateToNewGame
    case navigateToGames
    case navigateToLobby
    case clearGames
    case receiveGames(games: [GameInfo])
    case receiveUsers(users: [String])
    case receiveMessage(sender: String, message: String)
    case onlineLoadFinished
    case onlineLoadError(error: String)
    case onlineModeChanged(mode: OnlineMode)
    case gamesFilterToggle(filter: GamesFilter)
    case gamesSearchChanged(search: String)
    case selectGame(gameId: Int, showInfo: Bool)
    case closeGameInfo
    case newAutoGame
    case newGame
    case newGameCancel
    case passwordChanged(newPassword: String)
    case chatModeChanged(chatMode: ChatMode)
    case gameCreated(game: GameInfo)
    case gameChanged(game: GameInfo)
    case gameDeleted(gameId: Int)
    case userJoined(login: String)
    case userLeaved(login: String)
    case messageChanged(message: String)
    case windowWidthChanged(width: Int)
    case gameNameChanged(gameName: String)
    case gamePasswordChanged(gamePassword: String)
    case gamePackageTypeChanged(packageType: PackageType)
    case gamePackageDataChanged(packageName: String, packageData: Data? )
    case gamePackageLibraryChanged(name: String, id: String)
    case gameTypeChanged(gameType: GameType)
    case gameRoleChanged(gameRole: Role)
    case showmanTypeChanged(isHuman: Bool)
    case playersCountChanged(playersCount: Int)
    case humanPlayersCountChanged(humanPlayersCount: Int)
    case gameCreationStart
    case gameCreationEnd(error: String?)
    case gameSet(id: Int, isAutomatic: Bool, role: Role)
    case joinGameStarted
    case joinGameFinished(error: String)
    case uploadPackageStarted
    case uploadPackageFinished
    case uploadPackageProgress(progress: Int)
    case unselectGame
    case serverNameChanged(serverName: String)
    case searchPackages
    case searchPackagesFinished(packages: [SIPackageInfo])
    case receiveAuthors
    case receiveAuthorsFinished(authors: [SearchEntity])
    case receiveTags
    case receiveTagsFinished(tags: [SearchEntity])
    case receivePublishers
    case receivePublishersFinished(publishers: [SearchEntity])
}
