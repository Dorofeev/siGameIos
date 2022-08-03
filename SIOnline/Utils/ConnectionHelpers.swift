//
//  ConnectionHelpers.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 10.07.2022.
//

import ReSwift
import SwiftSignalRClient

class ConnectionHelpers {
    static var activeConnections: [String] = []
    
    static private var delegates: [String: ConnectionDelegateImpl] = [:]
    
    static func attachListeners(connection: HubConnection, dispatch: @escaping DispatchFunction) {
        connection.on(method: "Joined") { argumentExtractor in
            guard let login = try? argumentExtractor.getArgument(type: String.self) else { return }

            dispatch(ActionCreators.shared.userJoined(login: login))
        }
        
        connection.on(method: "Leaved") { argumentExtractor in
            guard let login = try? argumentExtractor.getArgument(type: String.self) else { return }
            
            dispatch(ActionCreators.shared.userLeaved(login: login))
        }
        
        connection.on(method: "Say") { argumentExtractor in
            guard let name = try? argumentExtractor.getArgument(type: String.self),
                  let text = try? argumentExtractor.getArgument(type: String.self) else { return }
            
            dispatch(ActionCreators.shared.receiveMessage(sender: name, message: text))
        }
        
        connection.on(method: "GameCreated") { argumentExtractor in
            guard let game = try? argumentExtractor.getArgument(type: GameInfo.self) else { return }
            
            dispatch(ActionCreators.shared.gameCreated(game: game))
        }
        
        connection.on(method: "GameChanged") { argumentExtractor in
            guard let game = try? argumentExtractor.getArgument(type: GameInfo.self) else { return }
            
            dispatch(ActionCreators.shared.gameChanged(game: game))
        }
        
        connection.on(method: "GameDeleted") { argumentExtractor in
            guard let id = try? argumentExtractor.getArgument(type: Int.self) else { return }
            
            dispatch(ActionCreators.shared.gameDeleted(gameId: id))
        }
        
        connection.on(method: "Receive") { argumentExtractor in
            guard let message = try? argumentExtractor.getArgument(type: Message.self), let dataContext = Index.dataContext else { return }
            
            MessageProcessor.messageProcessor(dispatch: dispatch, message: message, dataContext: dataContext)
        }
        
        connection.on(method: "Disconnect") { argumentExtractor in
            alert(text: R.string.localizable.youAreKicked())
            guard let dataContext = Index.dataContext else { return }
            dispatch(RunActionCreators.exitGame(dataContext))
        }
        
        guard let id = connection.connectionId else { return }
        let delegate = ConnectionDelegateImpl(dispatch: dispatch)
        connection.delegate = delegate
        delegates[id] = delegate
    }
    
    static func detachListeners(connection: HubConnection) {
        connection.delegate = nil
        delegates[connection.connectionId ?? ""] = nil
    }
}

class ConnectionDelegateImpl: HubConnectionDelegate {
        
    private let dispatch: DispatchFunction
    
    init(dispatch: @escaping DispatchFunction) {
        self.dispatch = dispatch
    }
    
    func connectionDidOpen(hubConnection connection: HubConnection) {}
    
    func connectionDidFailToOpen(error: Error) {}
    
    func connectionDidReceiveData(connection: Connection, data: Data) {}
    
    func connectionDidClose(error: Error?) {
        guard let dataContext = Index.dataContext else { return }
        dispatch(ActionCreators.shared.onConnectionChanged(
            dataContext: dataContext,
            isConnected: false,
            message: "\(R.string.localizable.connectionClosed()) \(error?.localizedDescription)")
        )
    }
    
    func connectionWillReconnect(error: Error) {
        guard let dataContext = Index.dataContext else { return }
        let errorMessage = error.localizedDescription
        
        dispatch(ActionCreators.shared.onConnectionChanged(
            dataContext: dataContext,
            isConnected: false,
            message: "\(R.string.localizable.connectionReconnecting()) \(errorMessage)")
        )
    }
    
    func connectionDidReconnect() {
        guard let dataContext = Index.dataContext else { return }
        dispatch(ActionCreators.shared.onConnectionChanged(
            dataContext: dataContext,
            isConnected: true,
            message: R.string.localizable.connectionReconnected())
        )
    }
}
