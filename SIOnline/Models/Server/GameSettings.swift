//
//  GameSettings.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 14.04.2022.
//

struct GameSettings {
    let humanPlayerName: String
    let randomSpecials: Bool
    let networkGameName: String
    let networkGamePassword: String
    let allowViewers: Bool
    let showman: AccountSettings
    let players: [AccountSettings]
    let viewers: [AccountSettings]
    let appSettings: ServerAppSettings
}
