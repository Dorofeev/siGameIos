//
//  TimeSettings.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 13.04.2022.
//

struct TimeSettings: Codable {
    let timeForChoosingQuestion: Int
    let timeForThinkingOnQuestion: Int
    let timeForPrintingAnswer: Int
    let timeForGivingACat: Int
    let timeForMakingStake: Int
    let timeForThinkingOnSpecial: Int
    let timeOfRound: Int
    let timeForChoosingFinalTheme: Int
    let timeForFinalThinking: Int
    let timeForShowmanDecisions: Int
    let timeForRightAnswer: Int
    let timeForMediaDelay: Int
    let timeForBlockingButton: Int
}
