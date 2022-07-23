//
//  Reducer.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 17.05.2022.
//

import ReSwift

let reducer: Reducer<State> = { action, state in
    var state = state ?? State.initialState()
    
    guard let action = action as? KnownAction else {
        if let runAction = action as? KnownRunAction {
            state.run = runReducer(runAction, state.run)
        }
        if let settingsAction = action as? KnownSettingsActions{
            state.settingsState = settingsReducer(settingsAction, state.settingsState)
        }
        return state
    }
    
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
    case .onlineLoadFinished:
        state.online.inProgress = false
    case .onlineLoadError(let error):
        state.online.inProgress = false
        state.online.error = error
    case .gamesFilterToggle(let filter):
        // TODO: - check how its working
        let rawValue = state.online.gamesFilter.rawValue ^ filter.rawValue
        state.online.gamesFilter = GamesFilter(rawValue: rawValue)!
    case .gamesSearchChanged(let search):
        state.online.gamesSearch = search
    case .selectGame(let gameId ,let showInfo):
        state.online.selectedGameId = gameId
        
        if showInfo {
            state.ui.onlineView = OnlineMode.gameInfo
        }
    case .closeGameInfo:
        state.ui.onlineView = OnlineMode.games
    case .passwordChanged(let newPassword):
        state.online.password = newPassword
    case .messageChanged(let message):
        state.online.currentMessage = message
    case .chatModeChanged(let chatMode):
        state.online.chatMode = chatMode
    case .onlineModeChanged(let mode):
        state.ui.onlineView = mode
    case .windowWidthChanged(let width):
        state.ui.windowWidth = width
    case .newGame:
        state.online.newGameShown = true
        state.online.gameCreationProgress = false
        state.online.gameCreationError = nil
        if state.game.name.isEmpty {
            state.game.name = "\(R.string.localizable.gameOf()) \(state.user.login)"
        }
    case .newGameCancel:
        state.online.newGameShown = false
        state.online.gameCreationError = nil
        state.online.gameCreationProgress = false
    case .gameNameChanged(let gameName):
        state.game.name = gameName
    case .gamePasswordChanged(let gamePassword):
        state.game.password = gamePassword
    case .gamePackageTypeChanged(let packageType):
        state.game.package.type = packageType
    case .gamePackageDataChanged(let packageName, let packageData):
        state.game.package.name = packageName
        state.game.package.data = packageData
    case .gamePackageLibraryChanged(let name, let id):
        state.game.package.name = name
        state.game.package.id = id
    case .gameTypeChanged(let gameType):
        state.game.type = gameType
    case .gameRoleChanged(let gameRole):
        state.game.role = gameRole
    case .showmanTypeChanged(let isHuman):
        state.game.isShowmanHuman = isHuman
    case .playersCountChanged(let playersCount):
        state.game.playersCount = playersCount
        state.game.humanPlayersCount = min(
            state.game.humanPlayersCount,
            playersCount - (state.game.role == Role.Player ? 1 : 0)
        )
    case.humanPlayersCountChanged(let humanPlayersCount):
        state.game.humanPlayersCount = humanPlayersCount
    case .gameCreationStart:
        state.online.gameCreationProgress = true
        state.online.gameCreationError = nil
    case .gameCreationEnd(let error):
        state.online.gameCreationProgress = false
        state.online.gameCreationError = error
    case .gameSet(let id, let isAutomatic, let role):
        state.game.id = id
        state.game.isAutomatic = isAutomatic
        state.ui.previousMainView = state.ui.mainView
        state.ui.mainView = MainView.game
        state.run = RunState.runInitialState()
        state.run.role = role
    case .joinGameStarted:
        state.online.joinGameProgress = true
        state.online.joingGameError = nil
    case .joinGameFinished(let error):
        state.online.joinGameProgress = false
        state.online.joingGameError = error
    case .uploadPackageStarted:
        state.online.uploadPackageProgress = true
        state.online.uploadPackagePercentage = 0
    case .uploadPackageFinished:
        state.online.uploadPackageProgress = false
    case .uploadPackageProgress(let progress):
        state.online.uploadPackagePercentage = progress
    case .serverInfoChanged(let serverName, let license):
        state.common.serverName = serverName
        state.common.serverLicense = license
    case .searchPackages:
        state.siPackages.isLoading = true
    case .searchPackagesFinished(let packages):
        state.siPackages.packages = packages
        state.siPackages.isLoading = false
    case .receiveAuthorsFinished(let authors):
        state.siPackages.authors = authors
    case .receiveTagsFinished(let tags):
        state.siPackages.tags = tags
    case .receivePublishersFinished(let publishers):
        state.siPackages.publishers = publishers
    default:
        break
    }
    return state
}
