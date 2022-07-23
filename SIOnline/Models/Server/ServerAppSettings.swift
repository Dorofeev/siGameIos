//
//  ServerAppSettings.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 14.04.2022.
//

struct ServerAppSettings: Encodable {
    let timeSettings: TimeSettings
    let readingSpeed: Int
    let falseStart: Bool
    let hintShowman: Bool
    let oral: Bool
    let ignoreWrong: Bool
    let gameMode: String
    let randomQuestionsBasePrice: Int
    let randomRoundsCount: Int
    let randomThemesCount: Int
    let culture: String
}
