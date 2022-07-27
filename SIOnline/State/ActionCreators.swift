//
//  ActionCreators.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 17.07.2022.
//

import Alamofire
import Foundation
import ReSwift
import ReSwiftThunk
import SwiftSignalRClient

class ActionCreators {
    static func isConnectedChanged(isConnected: Bool) -> KnownAction {
        .isConnectedChanged(isConnected: isConnected)
    }
    
    static func onConnectionChanged(dataContext: DataContext, isConnected: Bool, message: String) -> Thunk<State> {
        Thunk { dispatch, getState in
            dispatch(isConnectedChanged(isConnected: isConnected))
            
            guard let state = getState() else { return }
            
            if state.ui.mainView == .game {
                dispatch(RunActionCreators.chatMessageAdded(ChatMessage(sender: "", text: message)))
            } else {
                // TODO: - not yet implemented
                // dispatch(receiveMessage('', message));
            }
            
            if !isConnected { return }
            
            // Need to restore lobby/game previous state
            if state.ui.mainView == .game {
                dataContext.gameClient.sendMessageToServerAsync(message: "INFO")
            } else {
                // TODO: - Not yet implemented
                // navigateToLobby(-1)(dispatch, getState, dataContext);
            }
        }
    }
    
    static func computerAccountsChanged(computerAccounts: [String]) -> KnownAction {
        .computerAccountsChanged(computerAccounts: computerAccounts)
    }
    
    static func navigateToLogin() -> KnownAction {
        .navigateToLogin
    }
    
    static func showSettings(show: Bool) -> KnownAction {
        .showSettings(show: show)
    }
    
    static func navigateToHowToPlay() -> KnownAction {
        .navigateToHowToPlay
    }
    
    static func navigateBack() -> KnownAction {
        .navigateBack
    }
    
    static func onLoginChanged(newLogin: String) -> KnownAction {
        .loginChanged(newLogin: newLogin)
    }
    
    static func avatarLoadStart() -> KnownAction {
        .avatarLoadStart
    }
    
    static func avatarLoadEnd() -> KnownAction {
        .avatarLoadEnd
    }
    
    static func avatarChanged(avatar: String) -> KnownAction {
        .avatarChanged(avatar: avatar)
    }
    
    static func avatarLoadError(error: String?) -> KnownAction {
        .avatarLoadError(error: error)
    }
    
    static func onAvatarSelected(dataContext: DataContext, avatar: File) -> Thunk<State> {
        Thunk { dispatch, getState in
            dispatch(avatarLoadStart())
            
            let buffer = avatar.data
            
            // TODO: - Not yet implemented
            let hash = buffer // delete it
            // const hash = await hashData(buffer);
            
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
                            dispatch(avatarLoadError(error: "\(R.string.localizable.uploadingImageError()): \(response.response?.statusCode ?? 0) \(error.localizedDescription)"))
                        } else {
                            let avatarUri = response.value ?? ""
                            fullAvatarUri(avatarUri: avatarUri, dataContext: dataContext, dispatch: dispatch)
                        }
                        
                    }
                } else {
                    let avatarUri = result ?? ""
                    fullAvatarUri(avatarUri: avatarUri, dataContext: dataContext, dispatch: dispatch)
                }
            }
        }
    }
    
    private static func fullAvatarUri(avatarUri: String, dataContext: DataContext, dispatch: DispatchFunction) {
        let fullAvatarUri = dataContext.contentUris.isEmpty ? "" : dataContext.contentUris[0]
        
        dispatch(avatarLoadEnd())
        dispatch(avatarChanged(avatar: fullAvatarUri))
    }
    
    static func sendAvatar(dataContext: DataContext) -> Thunk<State> {
        Thunk { dispatch, getState in
            guard let state = getState() else { return }
            dataContext.gameClient.msgAsync(args: ["PICTURE", state.user.avatar ?? ""])
        }
    }
    
    static func loginStart() -> KnownAction {
        .loginStart
    }
    
    static func loginEnd(error: String? = nil) -> KnownAction {
        .loginEnd(error: error)
    }
    
    static func reloadComputerAccounts(dataContext: DataContext) -> Thunk<State> {
        Thunk { dispatch, getState in
            guard let state = getState() else { return }
            
            // TODO: - SIO-71 not yet implemented
            // const requestCulture = getFullCulture(state);
            
            let computerAccounts = dataContext.gameClient.getComputerAccountsAsync()
            computerAccounts.done { value in
                dispatch(computerAccountsChanged(computerAccounts: value))
            }
        }
    }
    
    static func saveStateToStorage(state: State) {
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
    
    static func getLoginErrorByCode(response: HTTPURLResponse) -> String {
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
    
    static func navigateToWelcome() -> KnownAction {
        .navigateToWelcome
    }
    
    static func serverInfoChanged(serverName: String, serverLicense: String) -> KnownAction {
        .serverInfoChanged(serverName: serverName, serverLicense: serverLicense)
    }
    
    static func loadHostInfoAsync(dispatch: @escaping DispatchFunction, dataContext: DataContext, culture: String) {
        let hostInfo = dataContext.gameClient.getGameHostInfoAsync(culture: culture)
        hostInfo.done { result in
            guard let urls = result.contentPublicBaseUrls else { return }
            dataContext.contentUris = urls
            dispatch(serverInfoChanged(serverName: result.name, serverLicense: result.license))
        }
    }
    
    static func friendsPlayInternal() -> KnownAction {
        .navigateToGames
    }
    
    static func selectGame(gameId: Int, showInfo: Bool) -> KnownAction {
        .selectGame(gameId: gameId, showInfo: showInfo)
    }
    
    static func clearGames() -> KnownAction {
        .clearGames
    }
    
    static func receiveGames(games: [GameInfo]) -> KnownAction {
        .receiveGames(games: games)
    }
    
    static func loadGamesAsync(dispatch: DispatchFunction, gameClient: IGameServerClient) async throws {
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
    
    static func onlineLoadFinish() -> KnownAction {
        .onlineLoadFinished
    }
    
    static func onlineLoadError(error: String) -> KnownAction {
        .onlineLoadError(error: error)
    }
    
    static func friendsPlay(dataContext: DataContext) -> Thunk<State> {
        Thunk { dispatch, getState in
            guard let state = getState() else { return }
            let selectedGameId = state.online.selectedGameId
            dispatch(friendsPlayInternal())
            Task {
                do {
                    try await loadGamesAsync(dispatch: dispatch, gameClient: dataContext.gameClient)
                    let state2 = getState()
                    
                    if selectedGameId != 0 && state2?.online.games[selectedGameId] != nil {
                        dispatch(selectGame(gameId: selectedGameId, showInfo: false))
                    }
                    
                    dispatch(onlineLoadFinish())
                } catch {
                    dispatch(onlineLoadError(error: getErrorMessage(e: error)))
                }
            }
        }
    }
    
    static func login(dataContext: DataContext) -> Thunk<State> {
        Thunk { dispatch, getState in
            dispatch(loginStart())
            
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
                            // TODO: - 
                            // activeConnections.push(dataContext.connection.connectionId);
                        }
                        
                    }
                    
                }
            }
        }
    }
}

class HubConnectionDelegateImpl: HubConnectionDelegate {
    
    private var connectionOpen: (() -> Void)?
    private var connectionFailed: ((Error) -> Void)?
    
    init(connectionOpen: @escaping () -> Void, connectionFailed: @escaping (Error) -> Void) {
        self.connectionOpen = connectionOpen
        self.connectionFailed = connectionFailed
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

//const login: ActionCreator<ThunkAction<void, State, DataContext, Action>> =
//() => async (dispatch: Dispatch<Actions.KnownAction>, getState: () => State, dataContext: DataContext) => {
//    dispatch(loginStart());
//
//    const state = getState();
//
//    try {
//        const response = await fetch(`${dataContext.serverUri}/api/Account/LogOn`, {
//        method: 'POST',
//        credentials: 'include',
//        body: `login=${state.user.login}&password=`,
//        headers: {
//            'Content-Type': 'application/x-www-form-urlencoded'
//        }
//        });
//
//        if (response.ok) {
//            saveStateToStorage(state);
//
//            const token = await response.text();
//            const queryString = `?token=${encodeURIComponent(token)}`;
//
//            let connectionBuilder = new signalR.HubConnectionBuilder()
//                .withAutomaticReconnect()
//                .withUrl(`${dataContext.serverUri}/sionline${queryString}`);
//
//            if (dataContext.config.useMessagePackProtocol) {
//                connectionBuilder = connectionBuilder.withHubProtocol(new signalRMsgPack.MessagePackHubProtocol());
//            }
//
//            const connection = connectionBuilder.build();
//            // eslint-disable-next-line no-param-reassign
//            dataContext.connection = connection;
//            // eslint-disable-next-line no-param-reassign
//            dataContext.gameClient = new GameServerClient(
//                connection,
//                e => dispatch(runActionCreators.operationError(getErrorMessage(e)) as object as Actions.KnownAction)
//            );
//
//            try {
//                await dataContext.connection.start();
//
//                if (dataContext.connection.connectionId) {
//                    activeConnections.push(dataContext.connection.connectionId);
//                }
//
//                attachListeners(dataContext.connection, dispatch);
//
//                const requestCulture = getFullCulture(state);
//
//                const computerAccounts = await dataContext.gameClient.getComputerAccountsAsync(requestCulture);
//                dispatch(computerAccountsChanged(computerAccounts));
//
//                dispatch(loginEnd());
//                dispatch(onLoginChanged(state.user.login.trim())); // Normalize login
//
//                await loadHostInfoAsync(dispatch, dataContext, requestCulture);
//
//                const urlParams = new URLSearchParams(window.location.search);
//                const invite = urlParams.get('invite');
//
//                if (state.online.selectedGameId && invite == 'true') {
//                    friendsPlay()(dispatch, getState, dataContext);
//                } else {
//                    dispatch(navigateToWelcome());
//                }
//            } catch (error) {
//                dispatch(loginEnd(`${localization.cannotConnectToServer}: ${getErrorMessage(error)}`));
//            }
//        } else {
//            const errorText = getLoginErrorByCode(response);
//            dispatch(loginEnd(errorText));
//        }
//    } catch (err) {
//        dispatch(loginEnd(`${localization.cannotConnectToServer}: ${getErrorMessage(err)}`));
//    }
//};
