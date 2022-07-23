//
//  ActionCreators.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 17.07.2022.
//

import Alamofire
import ReSwift
import ReSwiftThunk

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
        let hostInfo = dataContext.gameClient.getGameHostInfoAsync()
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
}
