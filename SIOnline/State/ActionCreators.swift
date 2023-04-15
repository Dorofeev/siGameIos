//
//  ActionCreators.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 17.07.2022.
//

import Alamofire
import CryptoKit
import Foundation
import ReSwift
import ReSwiftThunk
import SwiftSignalRClient
import PromiseKit

class ActionCreators: NSObject {
    
    static let shared: ActionCreators = ActionCreators()
    
    func isConnectedChanged(isConnected: Bool) -> KnownAction {
        .isConnectedChanged(isConnected: isConnected)
    }
    
    func onConnectionChanged(dataContext: DataContext, isConnected: Bool, message: String) -> Thunk<State> {
        Thunk { [unowned self] dispatch, getState in
            
            dispatch(self.isConnectedChanged(isConnected: isConnected))
            
            guard let state = getState() else { return }
            
            if state.ui.mainView == .game {
                dispatch(RunActionCreators.chatMessageAdded(ChatMessage(sender: "", text: message, messageLevel: .system)))
            } else {
                dispatch(self.receiveMessage(sender: "", message: message))
            }
            
            if !isConnected { return }
            
            // Need to restore lobby/game previous state
            if state.ui.mainView == .game {
                dataContext.gameClient.sendMessageToServerAsync(message: "INFO")
            } else {
                dispatch(navigateToLobby(dataContext: dataContext, gameId: -1, showInfo: nil))
            }
        }
    }
    
    func computerAccountsChanged(computerAccounts: [String]) -> KnownAction {
        .computerAccountsChanged(computerAccounts: computerAccounts)
    }
    
    func navigateToLogin() -> KnownAction {
        .navigateToLogin
    }
    
    func showSettings(show: Bool) -> KnownAction {
        .showSettings(show: show)
    }
    
    func navigateToHowToPlay() -> KnownAction {
        .navigateToHowToPlay
    }
    
    func navigateBack() -> KnownAction {
        .navigateBack
    }
    
    func onLoginChanged(newLogin: String) -> KnownAction {
        .loginChanged(newLogin: newLogin)
    }
    
    func avatarLoadStart() -> KnownAction {
        .avatarLoadStart
    }
    
    func avatarLoadEnd() -> KnownAction {
        .avatarLoadEnd
    }
    
    func avatarChanged(avatar: String) -> KnownAction {
        .avatarChanged(avatar: avatar)
    }
    
    func avatarLoadError(error: String?) -> KnownAction {
        .avatarLoadError(error: error)
    }
    
    func onAvatarSelected(dataContext: DataContext, avatar: File) -> Thunk<State> {
        Thunk { [unowned self] dispatch, getState in
            
            dispatch(self.avatarLoadStart())
            
            let buffer = avatar.data
            
            let hash = hashData(data: buffer)
            
            let hashArrayEncoded = hash.base64EncodedString()
            
            let imageKey = FileKey(name: avatar.name, hash: hashArrayEncoded)
            
            let gameClient = dataContext.gameClient
            let serverUri = dataContext.serverUri
            
            let avatarUri = gameClient.hasImageAsync(fileKey: imageKey)
            
            avatarUri.done { result in
                if result == nil {
                    let formData = MultipartFormData(fileManager: .default, boundary: nil)
                    formData.append(avatar.data, withName: "file", fileName: avatar.name, mimeType: nil)
                    
                    AF.upload(
                        multipartFormData: formData,
                        to: "\(serverUri)/api/upload/image",
                        headers: HTTPHeaders(["Content-MD5": hashArrayEncoded])
                    ).responseString { response in
                        if let error = response.error {
                            dispatch(self.avatarLoadError(error: "\(R.string.localizable.uploadingImageError()): \(response.response?.statusCode ?? 0) \(error.localizedDescription)"))
                        } else {
                            let avatarUri = response.value ?? ""
                            self.fullAvatarUri(avatarUri: avatarUri, dataContext: dataContext, dispatch: dispatch)
                        }
                        
                    }
                } else {
                    let avatarUri = result ?? ""
                    self.fullAvatarUri(avatarUri: avatarUri, dataContext: dataContext, dispatch: dispatch)
                }
            }
        }
    }
    
    private func fullAvatarUri(avatarUri: String, dataContext: DataContext, dispatch: DispatchFunction) {
        let fullAvatarUri = dataContext.contentUris.isEmpty ? "" : dataContext.contentUris[0]
        
        dispatch(avatarLoadEnd())
        dispatch(avatarChanged(avatar: fullAvatarUri))
    }
    
    func sendAvatar(dataContext: DataContext) -> Thunk<State> {
        Thunk { dispatch, getState in
            guard let state = getState() else { return }
            dataContext.gameClient.msgAsync(args: ["PICTURE", state.user.avatar ?? ""])
        }
    }
    
    func loginStart() -> KnownAction {
        .loginStart
    }
    
    func loginEnd(error: String? = nil) -> KnownAction {
        .loginEnd(error: error)
    }
    
    func reloadComputerAccounts(dataContext: DataContext) -> Thunk<State> {
        Thunk { [unowned self] dispatch, getState in
            guard let state = getState() else { return }
            
            let requestCulture = StateHelpers.shared.getFullCulture(state: state)
            
            let computerAccounts = dataContext.gameClient.getComputerAccountsAsync(culture: requestCulture)
            computerAccounts.done { value in
                dispatch(self.computerAccountsChanged(computerAccounts: value))
            }
        }
    }
    
    func saveStateToStorage(state: State) {
        SavedState.saveState(state: SavedState(
            login: state.user.login,
            game: SavedStateGame(
                name: state.game.name,
                password: state.game.password,
                role: state.game.role,
                type: state.game.type,
                playersCount: state.game.playersCount
            ),
            settings: state.settingsState
        ))
    }
    
    func getLoginErrorByCode(response: HTTPURLResponse) -> String {
        switch(response.statusCode) {
        case 0:
            return R.string.localizable.cannotConnectToServer()
        case 403:
            return R.string.localizable.forbiddenNickname()
        case 409:
            return R.string.localizable.duplicateUserName()
        default:
            return HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
        }
    }
    
    func navigateToWelcome() -> KnownAction {
        .navigateToWelcome
    }
    
    func serverInfoChanged(serverName: String, serverLicense: String) -> KnownAction {
        .serverInfoChanged(serverName: serverName, serverLicense: serverLicense)
    }
    
    func loadHostInfoAsync(dispatch: @escaping DispatchFunction, dataContext: DataContext, culture: String) async throws {
        let hostInfo = try await dataContext.gameClient.getGameHostInfoAsync(culture: culture).async()
        
        guard let urls = hostInfo.contentPublicBaseUrls else { return }
        dataContext.contentUris = urls
        dispatch(serverInfoChanged(serverName: hostInfo.name, serverLicense: hostInfo.license))
    }
    
    func friendsPlayInternal() -> KnownAction {
        .navigateToGames
    }
    
    func selectGame(gameId: Int, showInfo: Bool) -> KnownAction {
        .selectGame(gameId: gameId, showInfo: showInfo)
    }
    
    func clearGames() -> KnownAction {
        .clearGames
    }
    
    func receiveGames(games: [GameInfo]) -> KnownAction {
        .receiveGames(games: games)
    }
    
    func loadGamesAsync(dispatch: DispatchFunction, gameClient: IGameServerClient) async throws {
        dispatch(clearGames())
        var gameSlice: Slice<GameInfo> = Slice(data: [], isLastSlice: false)
        var whileGuard = 100
        
        repeat {
            let fromId = gameSlice.data.count > 0 ? gameSlice.data[gameSlice.data.count - 1].gameID + 1 : 0
            
            gameSlice = try await gameClient.getGamesSliceAsync(fromId: fromId).async()
            
            dispatch(receiveGames(games: gameSlice.data))
            whileGuard -= 1
        } while (!gameSlice.isLastSlice && whileGuard > 0)
    }
    
    func onlineLoadFinish() -> KnownAction {
        .onlineLoadFinished
    }
    
    func onlineLoadError(error: String) -> KnownAction {
        .onlineLoadError(error: error)
    }
    
    func friendsPlay(dataContext: DataContext) -> Thunk<State> {
        Thunk { [unowned self] dispatch, getState in
            guard let state = getState() else { return }
            let selectedGameId = state.online.selectedGameId
            dispatch(self.friendsPlayInternal())
            Task {
                do {
                    try await self.loadGamesAsync(dispatch: dispatch, gameClient: dataContext.gameClient)
                    let state2 = getState()
                    
                    if selectedGameId != 0 && state2?.online.games[selectedGameId] != nil {
                        dispatch(self.selectGame(gameId: selectedGameId, showInfo: false))
                    }
                    
                    dispatch(self.onlineLoadFinish())
                } catch {
                    dispatch(self.onlineLoadError(error: getErrorMessage(e: error)))
                }
            }
        }
    }
    
    func login(dataContext: DataContext) -> Thunk<State> {
        Thunk { [unowned self] dispatch, getState in
            dispatch(self.loginStart())
            
            guard let state = getState() else { return }
            Task {
                do {
                    guard let url = URL(string: "\(dataContext.serverUri)/api/Account/LogOn") else { return }
                    let response = try await withCheckedThrowingContinuation({ continuation in
                        AF.request(
                            url,
                            method: .post,
                            parameters: Parameters(dictionaryLiteral: ("login", state.user.login), ("password", "")),
                            headers: HTTPHeaders(["Content-Type": "application/x-www-form-urlencoded"])
                        ).responseString { response in
                            continuation.resume(returning: response)
                        }
                    })
                    
                    if response.response?.statusCode == 200 {
                        saveStateToStorage(state: state)
                        
                        guard let token = response.value else { return }
                        let queryString = "?token=\(token.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"
                        
                        guard let url = try? "\(dataContext.serverUri)/sionline\(queryString)".asURL() else { return }
                        let connectionBuilder = HubConnectionBuilder(url: url).withAutoReconnect()
                        
                        if dataContext.config.useMessagePackProtocol {
                            // Implement if needed
                            // connectionBuilder = connectionBuilder.withHubProtocol(new signalRMsgPack.MessagePackHubProtocol());
                        }
                        
                        let connection = connectionBuilder.build()
                        dataContext.connection = connection
                        dataContext.gameClient = GameServerClient(connection: connection, errorHandler: { error in
                            dispatch(RunActionCreators.operationError(getErrorMessage(e: error)))
                        })
                        
                        
                        let _: Void = try await withCheckedThrowingContinuation({ continuation in
                            let delegate = HubConnectionDelegateImpl(
                                connectionOpen: {
                                    continuation.resume()
                                },
                                connectionFailed: { error in
                                    continuation.resume(throwing: error)
                                }
                            )
                            connection.delegate = delegate
                            
                            connection.start()
                        })
                        
                        if let connectionId = connection.connectionId {
                            ConnectionHelpers.activeConnections.append(connectionId)
                        }
                        
                        ConnectionHelpers.attachListeners(connection: connection, dispatch: dispatch)
                        
                        let requestCulture = StateHelpers.shared.getFullCulture(state: state)
                        
                        let computerAccounts = try await dataContext.gameClient.getComputerAccountsAsync(culture: requestCulture).async()
                        dispatch(computerAccountsChanged(computerAccounts: computerAccounts))
                        
                        dispatch(loginEnd())
                        dispatch(onLoginChanged(newLogin: state.user.login.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))) // Normalize login
                        
                        try await loadHostInfoAsync(dispatch: dispatch, dataContext: dataContext, culture: requestCulture)
                        if state.online.selectedGameId != 0 && URLSearchParams.shared.invite {
                            dispatch(friendsPlay(dataContext: dataContext))
                        } else {
                            dispatch(navigateToWelcome())
                        }
                    } else {
                        guard let response = response.response else {
                            dispatch(loginEnd())
                            return
                        }
                        let errorText = getLoginErrorByCode(response: response)
                        dispatch(loginEnd(error: errorText))
                    }
                } catch {
                    dispatch(loginEnd(error: "\(R.string.localizable.cannotConnectToServer()) : \(getErrorMessage(e: error))"))
                }
            }
        }
    }
    
    func singlePlay() -> KnownAction {
        .navigateToNewGame
    }
    
    func navigateToLobbyInternal() -> KnownAction {
        .navigateToLobby
    }
    
    func navigateToLobby(dataContext: DataContext, gameId: Int, showInfo: Bool?) -> Thunk<State> {
        Thunk { [unowned self] dispatch, getState in
            dispatch(self.navigateToLobbyInternal())
            
            if gameId > -1 {
                dispatch(self.selectGame(gameId: gameId, showInfo: showInfo ?? false))
            } else if dataContext.config.rewriteUrl {
                // window.history.pushState({}, '', dataContext.config.rootUri);
                print("dataContext.config.rewriteUrl")
            }
            Task {
                do {
                    try await self.loadGamesAsync(dispatch: dispatch, gameClient: dataContext.gameClient)
                    
                    let users = try await dataContext.gameClient.getUsersAsync().async()
                    let sortedUsers = users.sorted(by: <)
                    
                    dispatch(receiveUsers(users: sortedUsers))
                    
                    let news = try await dataContext.gameClient.getNewsAsync().async()
                    
                    if let news = news {
                        dispatch(receiveMessage(sender: R.string.localizable.news(), message: news))
                    }
                    dispatch(self.onlineLoadFinish())
                } catch {
                    dispatch(self.onlineLoadError(error: getErrorMessage(e: error)))
                }
            }
        }
    }
    
    func navigateToError(error: String) -> KnownAction {
        .navigateToError(error: error)
    }
    
    func receiveUsers(users: [String]) -> KnownAction {
        .receiveUsers(users: users)
    }
    
    func receiveMessage(sender: String, message: String) -> KnownAction {
        .receiveMessage(sender: sender, message: message)
    }
    
    func onOnlineModeChanged(mode: OnlineMode) -> KnownAction {
        .onlineModeChanged(mode: mode)
    }
    
    func onExit(dataContext: DataContext) -> Thunk<State> {
        Thunk { [unowned self] dispatch, getState in
            guard let server = dataContext.connection else {
                return
            }
            
            Task {
                do {
                    try await dataContext.gameClient.logOutAsync().async()
                    if let connectionId = server.connectionId {
                        ConnectionHelpers.activeConnections.removeAll(where: { $0 == connectionId })
                    }
                    ConnectionHelpers.detachListeners(connection: server)
                    
                    let _: Void = try await withCheckedThrowingContinuation({ continuation in
                        let delegate = HubConnectionDelegateImpl(connectionDidClose: {
                            continuation.resume()
                        })
                        server.delegate = delegate
                        server.stop()
                    })
                    
                    dispatch(self.navigateToLogin())
                } catch {
                    alert(text: getErrorMessage(e: error)) // TODO: normal error message
                }
            }
        }
    }
    
    func onGamesFilterToggle(filter: GamesFilter) -> KnownAction {
        .gamesFilterToggle(filter: filter)
    }
    
    func onGamesSearchChanged(search: String) -> KnownAction {
        .gamesSearchChanged(search: search)
    }
    
    func closeGameInfo() -> KnownAction {
        .closeGameInfo
    }
    
    func unselectGame() -> KnownAction {
        .unselectGame
    }
    
    func newAutoGame() -> KnownAction {
        .newAutoGame
    }
    
    func newGame() -> KnownAction {
        .newGame
    }
    
    func newGameCancel() -> KnownAction {
        .newGameCancel
    }
    
    func joinGameStarted() -> KnownAction {
        .joinGameStarted
    }
    
    func joinGameFinished(error: String?) -> KnownAction {
        .joinGameFinished(error: error ?? "")
    }
    
    func joinGame(dataContext: DataContext, gameId: Int, role: Role) -> Thunk<State> {
        Thunk { [unowned self] dispatch, getState in
            dispatch(self.joinGameStarted())
            
            Task {
                do {
                    guard let state = getState() else { return }
                    
                    let result = try await dataContext.gameClient.joinGameAsync(
                        gameId: gameId,
                        role: role,
                        isMale: state.settingsState.sex == .male,
                        password: state.online.password
                    ).async()
                    
                    if !result.errorMessage.isEmpty {
                        dispatch(self.joinGameFinished(error: "\(R.string.localizable.joinError()): \(result.errorMessage)"))
                        return
                    }
                    
                    dispatch(gameSet(id: gameId, isAutomatic: false, role: role))
                    dispatch(TableActionCreators.showText(R.string.localizable.tableHint(), false))
                    
                    try await gameInit(gameId: gameId, dataContext: dataContext, role: role)
                    
                    self.saveStateToStorage(state: state)
                    dispatch(self.joinGameFinished(error: nil))
                }
                catch {
                    dispatch(self.joinGameFinished(error: getErrorMessage(e: error)))
                }
            }
        }
    }
    
    func passwordChanged(newPassword: String) -> KnownAction {
        .passwordChanged(newPassword: newPassword)
    }
    
    func chatModeChanged(chatMode: ChatMode) -> KnownAction {
        .chatModeChanged(chatMode: chatMode)
    }
    
    func gameCreated(game: GameInfo) -> KnownAction {
        .gameCreated(game: game)
    }
    
    func gameChanged(game: GameInfo) -> KnownAction {
        .gameChanged(game: game)
    }
    
    func gameDeleted(gameId: Int) -> KnownAction {
        .gameDeleted(gameId: gameId)
    }
    
    func userJoined(login: String) -> KnownAction {
        .userJoined(login: login)
    }
    
    func userLeaved(login: String) -> KnownAction {
        .userLeaved(login: login)
    }
    
    func messageChanged(message: String) -> KnownAction {
        .messageChanged(message: message)
    }
    
    func sendMessage(dataContext: DataContext) -> Thunk<State> {
        Thunk { [unowned self] dispatch, getState in
            guard let state = getState() else { return }
            
            let text = state.online.currentMessage.trimmingCharacters(in: .whitespacesAndNewlines)
            if !text.isEmpty {
                dataContext.gameClient.sayInLobbyAsync(text: text)
            }
            
            dispatch(self.messageChanged(message: ""))
        }
    }
    
    func windowSizeChanged(width: Int, height: Int) -> KnownAction {
        .windowSizeChanged(width: width, height: height)
    }
    
    func gameNameChanged(gameName: String) -> KnownAction {
        .gameNameChanged(gameName: gameName)
    }
    
    func gamePasswordChanged(gamePassword: String) -> KnownAction {
        .gamePasswordChanged(gamePassword: gamePassword)
    }
    
    func gamePackageTypeChanged(packageType: PackageType) -> KnownAction {
        .gamePackageTypeChanged(packageType: packageType)
    }
    
    func gamePackageDataChanged(packageName: String, packageData: File?) -> KnownAction {
        .gamePackageDataChanged(packageName: packageName, packageData: packageData)
    }
    
    func gamePackageLibraryChanged(id: String, name: String) -> KnownAction {
        .gamePackageLibraryChanged(name: name, id: id)
    }
    
    func gameTypeChanged(gameType: GameType) -> KnownAction {
        .gameTypeChanged(gameType: gameType)
    }
    
    func gameRoleChanged(gameRole: Role) -> KnownAction {
        .gameRoleChanged(gameRole: gameRole)
    }
    
    func showmanTypeChanged(isHuman: Bool) -> KnownAction {
        .showmanTypeChanged(isHuman: isHuman)
    }
    
    func playersCountChanged(playersCount: Int) -> KnownAction {
        .playersCountChanged(playersCount: playersCount)
    }
    
    func humanPlayersCountChanged(humanPlayersCount: Int) -> KnownAction {
        .humanPlayersCountChanged(humanPlayersCount: humanPlayersCount)
    }
    
    func gameCreationStart() -> KnownAction {
        .gameCreationStart
    }
    
    func gameCreationEnd(error: String? = nil) -> KnownAction {
        .gameCreationEnd(error: error)
    }
    
    func uploadPackageStarted() -> KnownAction {
        .uploadPackageStarted
    }
    
    func uploadPackageFinished() -> KnownAction {
        .uploadPackageFinished
    }
    
    func uploadPackageProgress(progress: Double) -> KnownAction {
        .uploadPackageProgress(progress: progress)
    }
    
    func uploadPackageAsync(packageHash: String, packageData: File, serverUrl: String, dispatch: @escaping DispatchFunction) -> Promise<Bool> {
        dispatch(uploadPackageStarted())
        let formData = MultipartFormData(fileManager: .default, boundary: nil)
        formData.append(packageData.data, withName: "file", fileName: packageData.name, mimeType: nil)
        
        return Promise { [unowned self] resolver in
            AF.upload(
                multipartFormData: formData,
                to: "\(serverUrl)/api/upload/package",
                headers: HTTPHeaders(["Content-MD5": packageHash])
            ).uploadProgress { progress in
                dispatch(self.uploadPackageProgress(progress: Double(progress.completedUnitCount) / Double(progress.totalUnitCount)))
            }.responseString { response in
                dispatch(self.uploadPackageFinished())
                if let error = response.error {
                    resolver.reject(error)
                } else {
                    resolver.fulfill(true)
                }
            }
        }
    }
    
    func hashData(data: Data) -> Data {
        let hash = Insecure.SHA1.hash(data: data)
        return Data(hash)
    }
    
    func checkAndUploadPackageAsync(
        gameClient: IGameServerClient,
        serverUrl: String,
        packageData: File,
        dispatch: DispatchFunction
    ) -> Promise<PackageKey> {
        fatalError("will be implemented in future")
    }
    
    func getRandomValue() -> Int {
        return Int.random(in: 0..<Int.max)
    }
    
    func createNewGame(dataContext: DataContext, isSingleGame: Bool) -> Thunk<State> {
        Thunk { [unowned self] dispatch, getState in
            guard let state = getState() else { return }
            
            if state.game.name.isEmpty || state.common.computerAccounts == nil {
                dispatch(self.gameCreationEnd(error: R.string.localizable.gameNameMustBeSpecified()))
                return
            }
            
            dispatch(self.gameCreationStart())
            
            // TODO: single game requires `isPrivate` flag, not random password to be closed for everyone
            // With `isRandom` flag game name could also be omitted
            Task {
                do {
                    var game = state.game
                    if isSingleGame {
                        game.password = String(self.getRandomValue())
                        game.isShowmanHuman = false
                        game.humanPlayersCount = 0
                    }
                    
                    let playersCount = game.playersCount
                    let humanPlayersCount = game.humanPlayersCount
                    let role = game.role
                    
                    let me = AccountSettings(name: state.user.login, isHuman: true, isMale: state.settingsState.sex == .male)
                    
                    var showman: AccountSettings
                    
                    if role == .Showman {
                        showman = me
                    } else if game.isShowmanHuman {
                        showman = AccountSettings(name: Constants.anyName, isHuman: true, isMale: false)
                    } else {
                        showman = AccountSettings(name: R.string.localizable.defaultShowman(), isHuman: false, isMale: false)
                    }
                    
                    var players = [AccountSettings]()
                    var viewers = [AccountSettings]()
                    
                    if role == .Viewer {
                        viewers.append(me)
                    } else if role == .Player {
                        players.append(me)
                    }
                    
                    let compPlayersCount = playersCount - humanPlayersCount - (role == .Player ? 1 : 0)
                    
                    var compIndicies = state.common.computerAccounts?.enumerated().map { $0.offset } ?? []
                    
                    for _ in 0..<humanPlayersCount {
                        players.append(AccountSettings(name: Constants.anyName, isHuman: true, isMale: false))
                    }
                    
                    for _ in 0..<compPlayersCount {
                        let ind = (0...compIndicies.count).randomElement() ?? 0
                        players.append(AccountSettings(name: state.common.computerAccounts![compIndicies[ind]], isHuman: false, isMale: false))
                        compIndicies.remove(at: ind)
                    }
                    
                    let gameMode = game.type
                    
                    let appSettings = ServerAppSettings(
                        timeSettings: state.settingsState.appSettings.timeSettings,
                        readingSpeed: state.settingsState.appSettings.readingSpeed,
                        falseStart: state.settingsState.appSettings.falseStart,
                        hintShowman: state.settingsState.appSettings.hintShowman,
                        oral: state.settingsState.appSettings.oral,
                        ignoreWrong: state.settingsState.appSettings.ignoreWrong,
                        gameMode: gameMode.toString(),
                        randomQuestionsBasePrice: gameMode == .Simple ? 10 : 100,
                        randomRoundsCount: gameMode == .Simple ? 1 : 3,
                        randomThemesCount: gameMode == .Simple ? 5 : 6,
                        culture: StateHelpers.shared.getFullCulture(state: state)
                    )
                    
                    let gameSettings = GameSettings(
                        humanPlayerName: state.user.login,
                        randomSpecials: game.package.type == .random,
                        networkGameName: game.name.trimmingCharacters(in: .whitespacesAndNewlines),
                        networkGamePassword: game.password,
                        allowViewers: true,
                        showman: showman,
                        players: players,
                        viewers: viewers,
                        appSettings: appSettings
                    )
                    
                    var packageKey: PackageKey? = nil
                    
                    switch game.package.type {
                    case .random:
                        packageKey = PackageKey(name: "", hash: nil, id: nil)
                    case .file:
                        if let data = game.package.data {
                            packageKey = try await self.checkAndUploadPackageAsync(
                                gameClient: dataContext.gameClient,
                                serverUrl: dataContext.serverUri,
                                packageData: data,
                                dispatch: dispatch
                            ).async()
                        }
                    case .siStorage:
                        packageKey = PackageKey(name: nil, hash: nil, id: game.package.id)
                    }
                    
                    guard let packageKey = packageKey else {
                        dispatch(self.gameCreationEnd(error: R.string.localizable.badPackage()))
                        return
                    }

                    let result = try await dataContext.gameClient.createAndJoinGameAsync(
                        gameSettings: gameSettings,
                        packageKey: packageKey,
                        isMale: state.settingsState.sex == .male
                    ).async()
                    
                    self.saveStateToStorage(state: state)
                    dispatch(self.gameCreationEnd(error: nil))
                    
                    if result.code.rawValue > 0 {
                        dispatch(gameCreationEnd(error: GameErrorsHelper.getMessage(code: result.code.rawValue) + " " + result.errorMessage))
                    } else {
                        dispatch(newGameCancel())
                        
                        dispatch(gameSet(id: result.gameId, isAutomatic: false, role: role))
                       
                        dispatch(TableActionCreators.showText(R.string.localizable.tableHint(), false))
                        
                        try await gameInit(gameId: result.gameId, dataContext: dataContext, role: role)
                    }
                } catch {
                    dispatch(gameCreationEnd(error: getErrorMessage(e: error)))
                }
            }
        }
    }
    
    func createNewAutoGame(dataContext: DataContext) -> Thunk<State> {
        Thunk { [unowned self] dispatch, getState in
            guard let state = getState() else { return }
            
            dispatch(self.gameCreationStart())
            
            Task {
                do {
                    let result = try await dataContext.gameClient.createAutomaticGameAsync(
                        login: state.user.login,
                        isMale: state.settingsState.sex == .male
                    ).async()
                    saveStateToStorage(state: state)
                    dispatch(gameCreationEnd(error: nil))
                    
                    if result.code.rawValue > 0 {
                        alert(text: GameErrorsHelper.getMessage(code: result.code.rawValue) + " " + result.errorMessage)
                    } else {
                        dispatch(gameSet(id: result.gameId, isAutomatic: true, role: .Player))
                        
                        dispatch(TableActionCreators.showText(R.string.localizable.tableHint(), false))
                        
                        try await gameInit(gameId: result.gameId, dataContext: dataContext, role: .Player)
                    }
                } catch {
                    dispatch(gameCreationEnd(error: error.localizedDescription))
                }
            }
        }
    }
    
    func gameSet(id: Int, isAutomatic: Bool, role: Role) -> KnownAction {
        .gameSet(id: id, isAutomatic: isAutomatic, role: role)
    }
    
    func gameInit(gameId: Int, dataContext: DataContext, role: Role) async throws {
        if dataContext.config.rewriteUrl {
            // TODO: - Implement Routing
            // window.history.pushState({}, `${localization.game} ${gameId}`, `${dataContext.config.rootUri}?gameId=${gameId}`);
        }
        
        try await dataContext.gameClient.sendMessageToServerAsync(message: "INFO").async()
        
        if role == .Player || role == .Showman {
            try await dataContext.gameClient.sendMessageToServerAsync(message: "READY").async()
        }
    }
    
    func searchPackages() -> KnownAction {
        .searchPackages
    }
    
    func searchPackagesFinished(packages: [SIPackageInfo]) -> KnownAction {
        .searchPackagesFinished(packages: packages)
    }
    
    func receiveAuthors() -> KnownAction {
        .receiveAuthors
    }
    
    func receiveAuthorsFinished(authors: [SearchEntity]) -> KnownAction {
        .receiveAuthorsFinished(authors: authors)
    }
    
    func receiveTags() -> KnownAction {
        .receiveTags
    }
    
    func receiveTagsFinished(tags: [SearchEntity]) -> KnownAction {
        .receiveTagsFinished(tags: tags)
    }
    
    func receivePublishers() -> KnownAction {
        .receivePublishers
    }
    
    func receivePublishersFinished(publishers: [SearchEntity]) -> KnownAction {
        .receivePublishersFinished(publishers: publishers)
    }
    
    func receiveAuthorsThunk(dataContext: DataContext) -> Thunk<State> {
        Thunk { [unowned self] dispatch, _ in
            Task {
                do {
                    dispatch(self.receiveAuthors())
                    let apiUrl = dataContext.config.apiUri
                    guard let url = URL(string: "\(apiUrl)/Authors") else { return }
                    let result: [SearchEntity] = try await withCheckedThrowingContinuation { continuation in
                        AF.request(url).responseDecodable { (response: DataResponse<[SearchEntity], AFError>) in
                            continuation.resume(with: response.result)
                        }
                    }
                    dispatch(self.receiveAuthorsFinished(authors: result))
                } catch {
                    Logger.log(message: error.localizedDescription)
                }
            }
        }
    }
    
    func receiveTagsThunk(dataContext: DataContext) -> Thunk<State> {
        Thunk { dispatch, _ in
            Task {
                do {
                    dispatch(self.receiveTags())
                    let apiUrl = dataContext.config.apiUri
                    guard let url = URL(string: "\(apiUrl)/Tags") else { return }
                    let result: [SearchEntity] = try await withCheckedThrowingContinuation { continuation in
                        AF.request(url).responseDecodable { (response: DataResponse<[SearchEntity], AFError>) in
                            continuation.resume(with: response.result)
                        }
                    }
                    dispatch(self.receiveTagsFinished(tags: result))
                } catch {
                    Logger.log(message: error.localizedDescription)
                }
            }
        }
    }
    
    func receivePublishersThunk(dataContext: DataContext) -> Thunk<State> {
        Thunk { dispatch, _ in
            Task {
                do {
                    dispatch(self.receivePublishers())
                    let apiUrl = dataContext.config.apiUri
                    guard let url = URL(string: "\(apiUrl)/Publishers") else { return }
                    let result: [SearchEntity] = try await withCheckedThrowingContinuation { continuation in
                        AF.request(url).responseDecodable { (response: DataResponse<[SearchEntity], AFError>) in
                            continuation.resume(with: response.result)
                        }
                    }
                    dispatch(self.receivePublishersFinished(publishers: result))
                } catch {
                    Logger.log(message: error.localizedDescription)
                }
            }
        }
    }
    
    func searchPackagesThunk(
        dataContext: DataContext,
        filters: PackageFilters = PackageFilters(
            difficultyRelation: 0,
            difficulty: 1,
            authorId: nil,
            sortMode: 0,
            sortAscending: true,
            publisherId: nil,
            tagId: nil,
            restriction: nil
        )
    ) -> Thunk<State> {
        Thunk { [unowned self] dispatch, _ in
            Task {
                do {
                    dispatch(self.searchPackages())
                    let apiUrl = dataContext.config.apiUri
                    guard let url = URL(string: "\(apiUrl)/FilteredPackages") else { return }
                    var parameters: [String: Any] = [
                        "difficultyRelation": filters.difficultyRelation,
                        "difficulty": filters.difficulty,
                        "sortMode": filters.sortMode,
                        "sortAscending": filters.sortAscending
                    ]
                    parameters["authorId"] = filters.authorId
                    parameters["publisherId"] = filters.publisherId
                    parameters["tagId"] = filters.tagId
                    parameters["restriction"] = filters.restriction
                    
                    let result: [SIPackageInfo] = try await withCheckedThrowingContinuation { continuation in
                        AF.request(url, parameters: parameters, encoding: URLEncoding.queryString).responseDecodable { (response: DataResponse<[SIPackageInfo], AFError>) in
                            continuation.resume(with: response.result)
                        }
                    }
                    dispatch(searchPackagesFinished(packages: result))
                } catch {
                    Logger.log(message: error.localizedDescription)
                }
            }
        }
    }
    
    func isSettingGameButtonKeyChanged(isSettingGameButtonKey: Bool) -> KnownAction {
        .isSettingGameButtonKeyChanged(isSettingGameButtonKey: isSettingGameButtonKey)
    }
}

class HubConnectionDelegateImpl: HubConnectionDelegate {
    
    private var connectionOpen: (() -> Void)?
    private var connectionFailed: ((Error) -> Void)?
    private var connectionDidClose: (() -> Void)?
    
    init(connectionOpen: @escaping () -> Void, connectionFailed: @escaping (Error) -> Void) {
        self.connectionOpen = connectionOpen
        self.connectionFailed = connectionFailed
    }
    
    init(connectionDidClose: @escaping () -> Void) {
        self.connectionDidClose = connectionDidClose
    }
    
    func connectionDidOpen(hubConnection: HubConnection) {
        connectionOpen?()
    }
    
    func connectionDidFailToOpen(error: Error) {
        connectionFailed?(error)
    }
    
    func connectionDidClose(error: Error?) {
        print("connectionDidClose \(error)")
    }
}
