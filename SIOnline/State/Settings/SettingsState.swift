//
//  SettingsState.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 09.04.2022.
//

struct SettingsState: Codable {
    var soundVolume: Int
    var showPersonsAtBottomOnWideScreen: Bool
    var sex: Sex
    var appSettings: AppSettings
    
    static func initialState() -> SettingsState {
        SettingsState(
            soundVolume: 1,
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
                ),
                culture: nil
            )
        )
    }
}
