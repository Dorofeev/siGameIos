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
    func getComputerAccountAsync(culture: String) -> Promise<[String]> {
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
}
