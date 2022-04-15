//
//  DataContext.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 13.04.2022.
//
import SwiftSignalRClient

struct DataContext {
    let config: Config
    let serverUri: String
    let connection: HubConnection?
    let gameClient: IGameServerClient
    let contentUris: [String]
}
