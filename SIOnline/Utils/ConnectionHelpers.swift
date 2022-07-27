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

            // TODO: - SIO-6 not yet implemented
            // dispatch(actionCreators.userJoined(login)));
        }
        
        connection.on(method: "Leaved") { argumentExtractor in
            guard let login = try? argumentExtractor.getArgument(type: String.self) else { return }
            
            // TODO: - SIO-6 not yet implemented
            // dispatch(actionCreators.userLeaved(login)));
        }
        
        connection.on(method: "Say") { argumentExtractor in
            guard let name = try? argumentExtractor.getArgument(type: String.self),
                  let text = try? argumentExtractor.getArgument(type: String.self) else { return }
            
            // TODO: - SIO-6 not yet implemented
            // dispatch(actionCreators.receiveMessage(name, text)));
        }
        
        connection.on(method: "GameCreated") { argumentExtractor in
            guard let game = try? argumentExtractor.getArgument(type: GameInfo.self) else { return }
            
            // TODO: - SIO-6 not yet implemented
            // dispatch(actionCreators.gameCreated(game)));
        }
        
        connection.on(method: "GameChanged") { argumentExtractor in
            guard let game = try? argumentExtractor.getArgument(type: GameInfo.self) else { return }
            
            // TODO: - SIO-6 not yet implemented
            // dispatch(actionCreators.gameChanged(game)));
        }
        
        connection.on(method: "GameDeleted") { argumentExtractor in
            guard let id = try? argumentExtractor.getArgument(type: Int.self) else { return }
            
            // TODO: - SIO-6 not yet implemented
            // dispatch(actionCreators.gameDeleted(id)));
        }
        
        connection.on(method: "Receive") { argumentExtractor in
            guard let message = try? argumentExtractor.getArgument(type: ChatMessage.self) else { return }
            
            // TODO: - SIO-6 not yet implemented
            // messageProcessor(dispatch, message));
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
        // TODO: - SIO-6 not yet implemented
        // dispatch(actionCreators.onConnectionChanged(false, `${localization.connectionClosed} ${e?.message || ''}`) as object as AnyAction);
    }
    
    func connectionWillReconnect(error: Error) {
        let errorMessage = error.localizedDescription
        
        // TODO: - SIO-6 not yet implemented
        //dispatch(actionCreators.onConnectionChanged(false, `${localization.connectionReconnecting}${errorMessage}`) as object as AnyAction);
    }
    
    func connectionDidReconnect() {
        // TODO: - SIO-6 not yet implemented
        // dispatch(actionCreators.onConnectionChanged(true, localization.connectionReconnected) as object as AnyAction);
    }
}
