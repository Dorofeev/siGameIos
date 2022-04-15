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
    
    /**
     * Creates an automatic game to play with anybody and joins it.
     * @param `login` User login.
     * @param `isMale` If person is a male (or female otherwise).
     */
    func createAutomaticGameAsync(login: String, isMale: Bool) -> Promise<GameCreationResult>
    
    /**
     * Joins an existsing game.
     * @param `gameId` Game identifier to join.
     * @param `role` Role to use.
     * @param `isMale` If person is a male (or female otherwise).
     * @param `password` Game password.
     */
    func joinGameAsync(gameId: Int, role: Role, isMale: Bool, password: String) -> Promise<GameCreationResult>
    
    /**
     * Sends a message inside game.
     * @param `message` Message to send.
     */
    func sendMessageToServerAsync(message: String) -> Promise<Any>
    
    /**
     * Sends a message inside game.
     * @param `args` Arguments to construct a message.
     */
    func msgAsync(args: [Any]) -> Promise<Any>
    
    /**
     * Sends a message in game chat.
     * @param `message` Message to send.
     */
    func sayAsync(message: String) -> Promise<Any>
    
    /** Leaves running game. */
    func leaveGameAsync() -> Promise<Any>
    
    /** Logs out from the server. */
    func logOutAsync() -> Promise<Any>
}
