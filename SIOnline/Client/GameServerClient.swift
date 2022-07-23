//
//  GameServerClient.swift
//  SIOnline
//
//  Created by Anna Kuptsova on 16.07.2022.
//
import SwiftSignalRClient
import PromiseKit
/** Represents a connection to a SIGame Server. */
class GameServerClient: IGameServerClient {
    private let connection: HubConnection
    private let errorHandler: (Any) -> Void
    
    init (connection: HubConnection, errorHandler: @escaping (Any) -> Void) {
        self.connection = connection
        self.errorHandler = errorHandler
    }
    func getComputerAccountsAsync(culture: String) -> Promise<[String]> {
        return Promise<[String]> { resolver in
            connection.invoke(method: "GetComputerAccountNew", culture, resultType: [String].self) { result, error in
                if let result = result {
                    resolver.fulfill(result)
                } else {
                    resolver.reject(error ?? UnknownError(message: "Failed to get computer account async"))
                }
            }
        }
    }
    func getGameHostInfoAsync(culture: String) -> Promise<HostInfo> {
        return Promise<HostInfo> { resolver in
            connection.invoke(method: "GetGamesHostInfoNew", culture, resultType: HostInfo.self) { result, error in
                if let result = result {
                    resolver.fulfill(result)
                } else {
                    resolver.reject(error ?? UnknownError(message: "Failed to get game host info async"))
                }
            }
        }
    }
    func getGamesSliceAsync(fromId: Int) -> Promise<Slice<GameInfo>> {
        return Promise<Slice<GameInfo>> { resolver in
            connection.invoke(method: "GetGamesSlice", fromId, resultType: Slice<GameInfo>.self) { result, error in
                if let result = result {
                    resolver.fulfill(result)
                } else  {
                    resolver.reject(error ?? UnknownError( message: "Failed to get games slice async"))
                }
            }
        }
    }
    func getUsersAsync() -> Promise<[String]> {
        return Promise<[String]> { resolver in
            connection.invoke(method: "GetUsers", resultType: [String].self) { result, error in
                if let result = result {
                    resolver.fulfill(result)
                } else {
                    resolver.reject(error ?? UnknownError(message: "Failed to get users async"))
                }
            }
        }
    }
    func getNewsAsync() -> Promise<String?> {
        return Promise<String?> { resolver in
            connection.invoke(method: "GetNews", resultType: String.self) { result, error in
                if let error = error {
                    resolver.reject(error)
                } else {
                    resolver.fulfill(result)
                }
            }
        }
    }
    func sayInLobbyAsync(text: String) -> Promise<Any> {
        return Promise<Any> { resolver in
            connection.invoke(method: "Say", text) { error in
                if let error = error {
                    resolver.reject(error)
                } else {
                    resolver.fulfill("")
                }
            }
        }
    }
    func hasPackageAsync(packageKey: PackageKey) -> Promise<Bool> {
        return Promise<Bool> { resolver in
            connection.invoke(method: "HasPackage", packageKey, resultType: Bool.self) { result, error in
                if let result = result {
                    resolver.fulfill(result)
                } else {
                    resolver.reject(error ?? UnknownError(message: "Failed to has package async"))
                }
            }
        }
    }
    func hasImageAsync(fileKey: FileKey) -> Promise<String?> {
        return Promise<String?> { resolver in
            connection.invoke(method: "HasPicture", fileKey, resultType: String.self) { result, error in
                if let error = error {
                    resolver.reject(error)
                } else {
                    resolver.fulfill(result)
                }
            }
        }
    }
    func createAndJoinGameAsync(gameSettings: GameSettings, packageKey: PackageKey, isMale: Bool) -> Promise<GameCreationResult> {
        return Promise<GameCreationResult> { resolver in
            connection.invoke(
                method: "CreareAndJoinGameNew",
                gameSettings,
                packageKey,
                [String](),
                isMale,
                resultType: GameCreationResult.self
            ) { result, error in
                if let result = result {
                    resolver.fulfill(result)
                } else {
                    resolver.reject(error ?? UnknownError(message: "Failed to create and join game async"))
                }
            }
        }
    }
    func createAutomaticGameAsync(login: String, isMale: Bool) -> Promise<GameCreationResult> {
        return Promise<GameCreationResult> {resolver in
            connection.invoke(method: "CreateAutomaticGameNew", login, isMale, resultType: GameCreationResult.self) { result, error in
                if let result = result {
                    resolver.fulfill(result)
                } else {
                    resolver.reject(error ?? UnknownError(message: "Failed to create automatic game async"))
                }
            }
        }
    }
    func joinGameAsync(gameId: Int, role: Role, isMale: Bool, password: String) -> Promise<GameCreationResult> {
        return Promise<GameCreationResult> { resolver in
            connection.invoke(method: "JoinGameNew", gameId, role, isMale, password, resultType: GameCreationResult.self) { result, error in
                if let result = result {
                    resolver.fulfill(result)
                } else {
                    resolver.reject(error ?? UnknownError(message: "Failed to join game asyng"))
                }
            }
        }
    }
    func sendMessageToServerAsync(message: String) -> Promise<Bool> {
        return Promise<Bool> { resolver in
            connection.invoke(method: "SendMessage", ["Text": message, "IsSystem": "true", "Receiver": "@"]) { [weak self] error in
                if let error = error {
                    self?.errorHandler(error)
                    resolver.fulfill(false)
                } else {
                    resolver.fulfill(true)
                }
            }
        }
    }
    func msgAsync(args: [String]) -> Promise<Bool> {
        return sendMessageToServerAsync(message: args.joined(separator: "\n"))
    }
    func sayAsync(message: String) -> Promise<Any> {
        return Promise<Any> { resolver in
            connection.invoke(method: "SendMessage", ["Text": message, "IsSystem": "false", "Receiver" : "*"]) { _ in
                resolver.fulfill("")
            }
        }
    }
    func leaveGameAsync() -> Promise<Any> {
        return Promise<Any> {resolver in
            connection.invoke(method: "LeaveGame") { _ in
                resolver.fulfill("")
            }
        }
    }
    func logOutAsync() -> Promise<Any> {
        return Promise<Any> { resolver in
            connection.invoke(method: "LogOut") { _ in
                resolver.fulfill("")
            }
        }
    }
}


