//
//  StateHelpers.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 13.08.2022.
//

class StateHelpers {
    static let shared = StateHelpers()
    
    func isHost(state: State) -> Bool {
        state.user.login == state.run.persons.hostName
    }
    
    func getCulture(state: State) -> String {
        state.settingsState.appSettings.culture ?? R.string.localizable.getLanguage()
    }
 
    func getFullCulture(state: State) -> String {
        getCulture(state: state) == "ru" ? "ru-RU" : "en-US"
    }
}
