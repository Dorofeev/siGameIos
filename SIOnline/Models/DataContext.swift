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
    let connection: HubConnection?
    let gameClient: IGameServerClient
    var contentUris: [String]
    
    init(config: Config, serverUri: String, connection: HubConnection?, gameClient: IGameServerClient, contentUris: [String]) {
        self.config = config
        self.serverUri = serverUri
        self.connection = connection
        self.gameClient = gameClient
        self.contentUris = contentUris
    }
}
