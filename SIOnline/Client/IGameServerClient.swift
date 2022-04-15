//
//  IGameServerClient.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 13.04.2022.
//
import PromiseKit
/** Defines the SIGame Server client. */
protocol IGameServerClient {
    /** Gets default computer accounts names. */
    func getComputerAccountsAsync() -> Promise<[String]>
    
    /** Gets server global info. */
    func getGameHostInfoAsync() -> Promise<HostInfo>
    
    /**
     * Gets partial running games list starting from the first game after the game with id {@link fromId}.
     * To receive all games from the server, use 0 as {@link fromId} value;
     * then use the last `gameId` in returned list as a new {@link fromId} value.
     * @param `fromId` gameId to start with.
     */
    func getGamesSliceAsync(fromId: Int) -> Promise<Slice<GameInfo>>
    
    /** Gets active users list in the lobby. */
    func getUsersAsync() -> Promise<[String]>
    
    /** Gets server news string. */
    func getNewsAsync() -> Promise<String?>
    
    /** Sends a message to the lobby chat. */
    func sayInLobbyAsync(text: String) -> Promise<Any>
    
    /**
     * Checks whether a specific package exists on a server.
     * If not, it must be uploaded first to start a new game with it.
     * @param `packageKey` Package key to check.
     */
    func hasPackageAsync(packageKey: PackageKey) -> Promise<Bool>
    
    /**
     * Creates a new game and joins it as a host.
     * @param `gameSettings` Game settings.
     * @param `packageKey` Package key to use.
     * @param `isMale` If host is a male person (or female otherwise).
     */
    func createAndJoinGameAsync(gameSettings: GameSettings, packageKey: PackageKey, isMale: Bool) -> Promise<GameCreationResult>
}
