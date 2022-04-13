//
//  SettingsState.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 09.04.2022.
//

struct SettingsState: Codable {
    let isSoundEnabled: Bool
    let showPersonsAtBottomOnWideScreen: Bool
    let sex: Sex
    let appSettings: AppSettings
    
    static func initialState() -> SettingsState {
        SettingsState(
            isSoundEnabled: false,
            showPersonsAtBottomOnWideScreen: true,
            sex: .male,
            appSettings: AppSettings(
                oral: false,
                falseStart: true,
                hintShowman: false,
                partialText: false,
                readingSpeed: 20,
                ignoreWrong: false,
                managed: false,
                timeSettings: TimeSettings(
                    timeForChoosingQuestion: 30,
                    timeForThinkingOnQuestion: 5,
                    timeForPrintingAnswer: 25,
                    timeForGivingACat: 30,
                    timeForMakingStake: 30,
                    timeForThinkingOnSpecial: 25,
                    timeOfRound: 660,
                    timeForChoosingFinalTheme: 30,
                    timeForFinalThinking: 45,
                    timeForShowmanDecisions: 30,
                    timeForRightAnswer: 2,
                    timeForMediaDelay: 0,
                    timeForBlockingButton: 3
                )
            )
        )
    }
}
