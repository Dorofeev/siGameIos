//
//  SavedState.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 08.04.2022.
//

struct SavedState {
    var login: String
    var game: SavedStateGame?
    var settings: SettingsState?
}

struct SavedStateGame {
    var name: String
    var password: String
    var role: Role
    var type: GameType
    var playersCount: Int
}
