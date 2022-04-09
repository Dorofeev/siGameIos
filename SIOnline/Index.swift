//
//  Index.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 08.04.2022.
//

private var config: Config?

class Index {
    func setState(state: State, savedState: SavedState?, gameId: String) -> State {
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
        
        newState.online.selectedGameId = Int(gameId) ?? -1
        
        return newState
    }
}
