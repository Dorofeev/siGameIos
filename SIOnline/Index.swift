//
//  Index.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 08.04.2022.
//
import Alamofire
import UIKit

class Index {
    private var config: Config?
    
    func setState(state: State, savedState: SavedState?, gameId: String?) -> State {
        guard let savedState = savedState else {
            return state
        }
        var newState = state
        newState.user.login = savedState.login
        if let game = savedState.game {
            newState.game.name = game.name
            newState.game.password = game.password
            newState.game.playersCount = game.playersCount
            newState.game.role = game.role
            newState.game.type = game.type
        }
        
        if let settings = savedState.settings {
            newState.settingsState = settings
        }
        
        newState.online.selectedGameId = Int(gameId ?? "") ?? -1
        
        return newState
    }
    
    func run(gameId: String?) {
        let startController = ViewController()
        let navController = UINavigationController(rootViewController: startController)
        startController.navigationItem.title = R.string.localizable.appTitle()
        
        guard let config = config else {
            fatalError("config is undefined")
        }
        let serverUri = config.serverUri
        if serverUri == nil {
            guard let serverDiscoveryUri = config.serverDiscoveryUri else {
                fatalError("Server uri is undefined!")
            }
            getServerUri(serverDiscoveryUri: serverDiscoveryUri) { [weak self] serverUri, error in
                if let error = error {
                    startController.showError(error: error)
                    return
                }
                guard let serverUri = serverUri, !serverUri.isEmpty else {
                    startController.showError(message: "Server uris object is broken!")
                    return
                }
                self?.run(with: serverUri[0].uri, state: State.initialState(), gameId: gameId)
            }
        } else {
            run(with: serverUri!, state: State.initialState(), gameId: gameId)
        }
        
    }
    
    private func run(with Uri: String, state: State, gameId: String?) {
        let savedState = SavedState.loadState()
        setState(state: state, savedState: savedState, gameId: gameId)
        
        //let dataContext =
    }
    
    private func getServerUri(serverDiscoveryUri: String, completion: @escaping ([ServerInfo]?, AFError?) -> ()) {
        // Using random number to prevent serverUri caching
        AF.request(serverDiscoveryUri + "?r=\(arc4random())").responseDecodable(of: [ServerInfo].self) { response in
            debugPrint(response)
            completion(response.value, response.error)
        }
    }
}
