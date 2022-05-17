//
//  SettingsActions.swift
//  SIOnline
//
//  Created by Anna Kuptsova on 15.05.2022.
//

import ReSwift

typealias KnownSettingsActions = SettingsActionTypes

enum SettingsActionTypes: Action {
    case soundVolumeChanged(volume: Int)
    case showPersonsAtBottomOnWideScreenChanged(showPersonsAtBottomOnWideScreen: Bool)
    case sexChanged(newSex: Sex)
    case oralChanged(oral: Bool)
    case falseStartsChanged(falseStarts: Bool)
    case hintShowmanChanged(hintShowman: Bool)
    case partialTextChanged(partialText: Bool)
    case readingSpeedChanged(readingSpeed: Int)
    case managedChanged(managed: Bool)
    case ignoreWrongChanged(ignoreWrong: Bool)
    case timeSettingChanged(name: String, value: Int)
    case resetSettings
    case languageChanged(language: String?)
}
