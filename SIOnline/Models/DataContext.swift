//
//  DataContext.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 13.04.2022.
//
import SwiftSignalRClient

class DataContext {
    let config: Config
    let serverUri: String
    var connection: HubConnection?
    var gameClient: IGameServerClient
    var contentUris: [String]
    
    init(config: Config, serverUri: String, connection: HubConnection?, gameClient: IGameServerClient, contentUris: [String]) {
        self.config = config
        self.serverUri = serverUri
        self.connection = connection
        self.gameClient = gameClient
        self.contentUris = contentUris
    }
    
    static func mock() -> DataContext {
        let config = Config(serverUri: nil, apiUri: "", serverDiscoveryUri: nil, rootUri: "", useMessagePackProtocol: false, ads: "", forceHttps: false, rewriteUrl: false)
        let gameClient = DummyGameServerClient()
        return DataContext(config: config, serverUri: "", connection: nil, gameClient: gameClient, contentUris: [])
    }
}

