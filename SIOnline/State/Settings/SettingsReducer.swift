//
//  SettingsReducer.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 15.05.2022.
//

import ReSwift

let settingsReducer: Reducer<SettingsState> = { action, state in
    var state = state ?? SettingsState.initialState()
    
    guard let action = action as? KnownSettingsActions else { return state }
    
    switch action {
    case .soundVolumeChanged(let volume):
        state.soundVolume = volume
    case .showPersonsAtBottomOnWideScreenChanged(let showPersonsAtBottomOnWideScreen):
        state.showPersonsAtBottomOnWideScreen = showPersonsAtBottomOnWideScreen
    case .sexChanged(let newSex):
        state.sex = newSex
    case .oralChanged(let oral):
        state.appSettings.oral = oral
    case .falseStartsChanged(let falseStarts):
        state.appSettings.falseStart = falseStarts
    case .hintShowmanChanged(let hintShowman):
        state.appSettings.hintShowman = hintShowman
    case .partialTextChanged(let partialText):
        state.appSettings.partialText = partialText
    case .readingSpeedChanged(let readingSpeed):
        state.appSettings.readingSpeed = readingSpeed
    case .managedChanged(let managed):
        state.appSettings.managed = managed
    case .ignoreWrongChanged(let ignoreWrong):
        state.appSettings.ignoreWrong = ignoreWrong
    case .timeSettingChanged(let name, let value):
        state.appSettings.timeSettings[name] = value
    case .languageChanged(let language):
        state.appSettings.culture = language
    case .resetSettings:
        state = .initialState()
    }
    return state
}
