//
//  State.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 08.04.2022.
//

struct State {
    var user: StateUser
    var game: StateGame
    var settingsState: SettingsState
    var online: StateOnline
}

struct StateUser {
    var login: String
}

struct StateGame {
    var name: String
    var password: String
    var role: Role
    var playersCount: Int
    var type: GameType
}

struct StateOnline {
    var selectedGameId: Int
}
