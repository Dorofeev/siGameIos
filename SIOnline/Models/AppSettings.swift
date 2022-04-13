//
//  AppSettings.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 13.04.2022.
//

struct AppSettings: Codable {
    let oral: Bool
    let falseStart: Bool
    let hintShowman: Bool
    let partialText: Bool
    let readingSpeed: Int
    let ignoreWrong: Bool
    let managed: Bool
    let timeSettings: TimeSettings
}
