//
//  DummyGameServerClient.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 15.04.2022.
//

import PromiseKit

/** Defines a disconnected version of IGameServerClient. */
class DummyGameServerClient: IGameServerClient {
    
    private let error: NSError = NSError(domain: "DummyGameServerClient", code: 500, userInfo: [NSLocalizedDescriptionKey: "Connection is closed!"])
    
    func getComputerAccountsAsync(culture: String) -> Promise<[String]> {
        return Promise { promise in
            promise.resolve([], nil)
        }
    }
    
    func getGameHostInfoAsync(culture: String) -> Promise<HostInfo> {
        return Promise { promise in
            promise.resolve(nil, error)
        }
    }
    
    func getGamesSliceAsync(fromId: Int) -> Promise<Slice<GameInfo>> {
        return Promise { promise in
            promise.resolve(nil, error)
        }
    }
    
    func getUsersAsync() -> Promise<[String]> {
        return Promise { promise in
            promise.resolve([], nil)
        }
    }
    
    func getNewsAsync() -> Promise<String?> {
        return Promise { promise in
            promise.resolve(.some(nil), nil)
        }
    }
    
    func sayInLobbyAsync(text: String) -> Promise<Any> {
        return Promise { promise in
            promise.resolve(.none, nil)
        }
    }
    
    func hasPackageAsync(packageKey: PackageKey) -> Promise<Bool> {
        return Promise { promise in
            promise.resolve(false, nil)
        }
    }
    
    func createAndJoinGameAsync(gameSettings: GameSettings, packageKey: PackageKey, isMale: Bool) -> Promise<GameCreationResult> {
        return Promise { promise in
            promise.resolve(nil, error)
        }
    }
    
    func createAutomaticGameAsync(login: String, isMale: Bool) -> Promise<GameCreationResult> {
        return Promise { promise in
            promise.resolve(nil, error)
        }
    }
    
    func joinGameAsync(gameId: Int, role: Role, isMale: Bool, password: String) -> Promise<GameCreationResult> {
        return Promise { promise in
            promise.resolve(nil, error)
        }
    }
    
    func sendMessageToServerAsync(message: String) -> Promise<Bool> {
        return Promise { promise in
            promise.resolve(false, nil)
        }
    }
    
    func msgAsync(args: [String]) -> Promise<Bool> {
        return Promise { promise in
            promise.resolve(.none, error)
        }
    }
    
    func sayAsync(message: String) -> Promise<Any> {
        return Promise { promise in
            promise.resolve(.none, error)
        }
    }
    
    func leaveGameAsync() -> Promise<Any> {
        return Promise { promise in
            promise.resolve(.none, error)
        }
    }
    
    func logOutAsync() -> Promise<Any> {
        return Promise { promise in
            promise.resolve(.none, error)
        }
    }
}
