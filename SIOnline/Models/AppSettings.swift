//
//  AppSettings.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 13.04.2022.
//

struct AppSettings: Codable {
    var oral: Bool
    var falseStart: Bool
    var hintShowman: Bool
    var partialText: Bool
    var readingSpeed: Int
    var ignoreWrong: Bool
    var managed: Bool
    var timeSettings: TimeSettings
    var culture: String?
}
